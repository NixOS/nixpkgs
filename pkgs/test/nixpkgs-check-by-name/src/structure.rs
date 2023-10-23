use crate::check_result;
use crate::check_result::{CheckProblem, CheckResult};
use crate::references;
use crate::utils;
use crate::utils::{BASE_SUBPATH, PACKAGE_NIX_FILENAME};
use lazy_static::lazy_static;
use regex::Regex;
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

/// Read the structure of a Nixpkgs directory, displaying errors on the writer.
/// May return early with I/O errors.
pub fn check_structure(path: &Path) -> CheckResult<Vec<String>> {
    let base_dir = path.join(BASE_SUBPATH);

    let shard_results = utils::read_dir_sorted(&base_dir)?
        .into_iter()
        .map(|shard_entry| {
            let shard_path = shard_entry.path();
            let shard_name = shard_entry.file_name().to_string_lossy().into_owned();
            let relative_shard_path = relative_dir_for_shard(&shard_name);

            if shard_name == "README.md" {
                // README.md is allowed to be a file and not checked
                check_result::ok(vec![])
            } else if !shard_path.is_dir() {
                CheckProblem::ShardNonDir {
                    relative_shard_path: relative_shard_path.clone(),
                }
                .into_result()
                // we can't check for any other errors if it's a file, since there's no subdirectories to check
            } else {
                let shard_name_valid = SHARD_NAME_REGEX.is_match(&shard_name);
                let result = if !shard_name_valid {
                    CheckProblem::InvalidShardName {
                        relative_shard_path: relative_shard_path.clone(),
                        shard_name: shard_name.clone(),
                    }
                    .into_result()
                } else {
                    check_result::ok(())
                };

                let entries = utils::read_dir_sorted(&shard_path)?;

                let duplicate_results = entries
                    .iter()
                    .zip(entries.iter().skip(1))
                    .filter(|(l, r)| {
                        l.file_name().to_ascii_lowercase() == r.file_name().to_ascii_lowercase()
                    })
                    .map(|(l, r)| {
                        CheckProblem::CaseSensitiveDuplicate {
                            relative_shard_path: relative_shard_path.clone(),
                            first: l.file_name(),
                            second: r.file_name(),
                        }
                        .into_result::<()>()
                    });

                let result = check_result::and(result, check_result::sequence_(duplicate_results));

                let package_results = entries.into_iter().map(|package_entry| {
                    let package_path = package_entry.path();
                    let package_name = package_entry.file_name().to_string_lossy().into_owned();
                    let relative_package_dir =
                        PathBuf::from(format!("{BASE_SUBPATH}/{shard_name}/{package_name}"));

                    if !package_path.is_dir() {
                        CheckProblem::PackageNonDir {
                            relative_package_dir: relative_package_dir.clone(),
                        }
                        .into_result()
                    } else {
                        let package_name_valid = PACKAGE_NAME_REGEX.is_match(&package_name);
                        let result = if !package_name_valid {
                            CheckProblem::InvalidPackageName {
                                relative_package_dir: relative_package_dir.clone(),
                                package_name: package_name.clone(),
                            }
                            .into_result()
                        } else {
                            check_result::ok(())
                        };

                        let correct_relative_package_dir = relative_dir_for_package(&package_name);
                        let result = check_result::and(
                            result,
                            if relative_package_dir != correct_relative_package_dir {
                                // Only show this error if we have a valid shard and package name
                                // Because if one of those is wrong, you should fix that first
                                if shard_name_valid && package_name_valid {
                                    CheckProblem::IncorrectShard {
                                        relative_package_dir: relative_package_dir.clone(),
                                        correct_relative_package_dir: correct_relative_package_dir
                                            .clone(),
                                    }
                                    .into_result()
                                } else {
                                    check_result::ok(())
                                }
                            } else {
                                check_result::ok(())
                            },
                        );

                        let package_nix_path = package_path.join(PACKAGE_NIX_FILENAME);
                        let result = check_result::and(
                            result,
                            if !package_nix_path.exists() {
                                CheckProblem::PackageNixNonExistent {
                                    relative_package_dir: relative_package_dir.clone(),
                                }
                                .into_result()
                            } else if package_nix_path.is_dir() {
                                CheckProblem::PackageNixDir {
                                    relative_package_dir: relative_package_dir.clone(),
                                }
                                .into_result()
                            } else {
                                check_result::ok(())
                            },
                        );

                        let result = check_result::and(
                            result,
                            references::check_references(
                                &relative_package_dir,
                                &path.join(&relative_package_dir),
                            ),
                        );

                        check_result::map(result, |_| package_name.clone())
                    }
                });

                check_result::and(result, check_result::sequence(package_results))
            }
        });

    check_result::map(check_result::sequence(shard_results), |x| {
        x.into_iter().flatten().collect::<Vec<_>>()
    })
}
