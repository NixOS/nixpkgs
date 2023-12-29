use crate::nixpkgs_problem::NixpkgsProblem;
use crate::references;
use crate::utils;
use crate::utils::{BASE_SUBPATH, PACKAGE_NIX_FILENAME};
use crate::validation::{self, ResultIteratorExt, Validation::Success};
use itertools::concat;
use lazy_static::lazy_static;
use regex::Regex;
use std::fs::DirEntry;
use std::path::{Path, PathBuf};

lazy_static! {
    static ref SHARD_NAME_REGEX: Regex = Regex::new(r"^[a-z0-9_-]{1,2}$").unwrap();
    static ref PACKAGE_NAME_REGEX: Regex = Regex::new(r"^[a-zA-Z0-9_-]+$").unwrap();
}

// Some utility functions for the basic structure

pub fn shard_for_package(package_name: &str) -> String {
    package_name.to_lowercase().chars().take(2).collect()
}

pub fn relative_dir_for_shard(shard_name: &str) -> PathBuf {
    PathBuf::from(format!("{BASE_SUBPATH}/{shard_name}"))
}

pub fn relative_dir_for_package(package_name: &str) -> PathBuf {
    relative_dir_for_shard(&shard_for_package(package_name)).join(package_name)
}

pub fn relative_file_for_package(package_name: &str) -> PathBuf {
    relative_dir_for_package(package_name).join(PACKAGE_NIX_FILENAME)
}

/// Check the structure of Nixpkgs, returning the attribute names that are defined in
/// `pkgs/by-name`
pub fn check_structure(path: &Path) -> validation::Result<Vec<String>> {
    let base_dir = path.join(BASE_SUBPATH);

    let shard_results = utils::read_dir_sorted(&base_dir)?
        .into_iter()
        .map(|shard_entry| -> validation::Result<_> {
            let shard_path = shard_entry.path();
            let shard_name = shard_entry.file_name().to_string_lossy().into_owned();
            let relative_shard_path = relative_dir_for_shard(&shard_name);

            Ok(if shard_name == "README.md" {
                // README.md is allowed to be a file and not checked

                Success(vec![])
            } else if !shard_path.is_dir() {
                NixpkgsProblem::ShardNonDir {
                    relative_shard_path: relative_shard_path.clone(),
                }
                .into()
                // we can't check for any other errors if it's a file, since there's no subdirectories to check
            } else {
                let shard_name_valid = SHARD_NAME_REGEX.is_match(&shard_name);
                let result = if !shard_name_valid {
                    NixpkgsProblem::InvalidShardName {
                        relative_shard_path: relative_shard_path.clone(),
                        shard_name: shard_name.clone(),
                    }
                    .into()
                } else {
                    Success(())
                };

                let entries = utils::read_dir_sorted(&shard_path)?;

                let duplicate_results = entries
                    .iter()
                    .zip(entries.iter().skip(1))
                    .filter(|(l, r)| {
                        l.file_name().to_ascii_lowercase() == r.file_name().to_ascii_lowercase()
                    })
                    .map(|(l, r)| {
                        NixpkgsProblem::CaseSensitiveDuplicate {
                            relative_shard_path: relative_shard_path.clone(),
                            first: l.file_name(),
                            second: r.file_name(),
                        }
                        .into()
                    });

                let result = result.and(validation::sequence_(duplicate_results));

                let package_results = entries
                    .into_iter()
                    .map(|package_entry| {
                        check_package(path, &shard_name, shard_name_valid, package_entry)
                    })
                    .collect_vec()?;

                result.and(validation::sequence(package_results))
            })
        })
        .collect_vec()?;

    // Combine the package names conatained within each shard into a longer list
    Ok(validation::sequence(shard_results).map(concat))
}

fn check_package(
    path: &Path,
    shard_name: &str,
    shard_name_valid: bool,
    package_entry: DirEntry,
) -> validation::Result<String> {
    let package_path = package_entry.path();
    let package_name = package_entry.file_name().to_string_lossy().into_owned();
    let relative_package_dir = PathBuf::from(format!("{BASE_SUBPATH}/{shard_name}/{package_name}"));

    Ok(if !package_path.is_dir() {
        NixpkgsProblem::PackageNonDir {
            relative_package_dir: relative_package_dir.clone(),
        }
        .into()
    } else {
        let package_name_valid = PACKAGE_NAME_REGEX.is_match(&package_name);
        let result = if !package_name_valid {
            NixpkgsProblem::InvalidPackageName {
                relative_package_dir: relative_package_dir.clone(),
                package_name: package_name.clone(),
            }
            .into()
        } else {
            Success(())
        };

        let correct_relative_package_dir = relative_dir_for_package(&package_name);
        let result = result.and(if relative_package_dir != correct_relative_package_dir {
            // Only show this error if we have a valid shard and package name
            // Because if one of those is wrong, you should fix that first
            if shard_name_valid && package_name_valid {
                NixpkgsProblem::IncorrectShard {
                    relative_package_dir: relative_package_dir.clone(),
                    correct_relative_package_dir: correct_relative_package_dir.clone(),
                }
                .into()
            } else {
                Success(())
            }
        } else {
            Success(())
        });

        let package_nix_path = package_path.join(PACKAGE_NIX_FILENAME);
        let result = result.and(if !package_nix_path.exists() {
            NixpkgsProblem::PackageNixNonExistent {
                relative_package_dir: relative_package_dir.clone(),
            }
            .into()
        } else if package_nix_path.is_dir() {
            NixpkgsProblem::PackageNixDir {
                relative_package_dir: relative_package_dir.clone(),
            }
            .into()
        } else {
            Success(())
        });

        let result = result.and(references::check_references(
            &relative_package_dir,
            &path.join(&relative_package_dir),
        )?);

        result.map(|_| package_name.clone())
    })
}
