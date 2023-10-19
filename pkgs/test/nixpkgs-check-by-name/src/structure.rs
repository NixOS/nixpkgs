use crate::check_result::{flatten_check_results, pass, write_check_result, CheckError};
use crate::utils;
use crate::utils::{ErrorWriter, BASE_SUBPATH, PACKAGE_NIX_FILENAME};
use lazy_static::lazy_static;
use regex::Regex;
use std::io;
use std::path::{Path, PathBuf};

lazy_static! {
    static ref SHARD_NAME_REGEX: Regex = Regex::new(r"^[a-z0-9_-]{1,2}$").unwrap();
    static ref PACKAGE_NAME_REGEX: Regex = Regex::new(r"^[a-zA-Z0-9_-]+$").unwrap();
}

/// Contains information about the structure of the pkgs/by-name directory of a Nixpkgs
pub struct Nixpkgs {
    /// The path to nixpkgs
    pub path: PathBuf,
    /// The names of all packages declared in pkgs/by-name
    pub package_names: Vec<String>,
}

impl Nixpkgs {
    // Some utility functions for the basic structure

    pub fn shard_for_package(package_name: &str) -> String {
        package_name.to_lowercase().chars().take(2).collect()
    }

    pub fn relative_dir_for_shard(shard_name: &str) -> PathBuf {
        PathBuf::from(format!("{BASE_SUBPATH}/{shard_name}"))
    }

    pub fn relative_dir_for_package(package_name: &str) -> PathBuf {
        Nixpkgs::relative_dir_for_shard(&Nixpkgs::shard_for_package(package_name))
            .join(package_name)
    }

    pub fn relative_file_for_package(package_name: &str) -> PathBuf {
        Nixpkgs::relative_dir_for_package(package_name).join(PACKAGE_NIX_FILENAME)
    }
}

impl Nixpkgs {
    /// Read the structure of a Nixpkgs directory, displaying errors on the writer.
    /// May return early with I/O errors.
    pub fn new<W: io::Write>(
        path: &Path,
        error_writer: &mut ErrorWriter<W>,
    ) -> anyhow::Result<Nixpkgs> {
        let base_dir = path.join(BASE_SUBPATH);

        let mut package_names = Vec::new();

        for shard_entry in utils::read_dir_sorted(&base_dir)? {
            let shard_path = shard_entry.path();
            let shard_name = shard_entry.file_name().to_string_lossy().into_owned();
            let relative_shard_path = Nixpkgs::relative_dir_for_shard(&shard_name);

            if shard_name == "README.md" {
                // README.md is allowed to be a file and not checked
                continue;
            }

            let check_result = if !shard_path.is_dir() {
                CheckError::ShardNonDir {
                    relative_shard_path: relative_shard_path.clone(),
                }
                .into_result()
                // we can't check for any other errors if it's a file, since there's no subdirectories to check
            } else {
                let shard_name_valid = SHARD_NAME_REGEX.is_match(&shard_name);
                let shard_name_valid_check_result = if !shard_name_valid {
                    CheckError::InvalidShardName {
                        relative_shard_path: relative_shard_path.clone(),
                        shard_name: shard_name.clone(),
                    }
                    .into_result()
                } else {
                    pass(())
                };

                write_check_result(error_writer, shard_name_valid_check_result)?;

                let entries = utils::read_dir_sorted(&shard_path)?;

                let duplicate_check_results = entries
                    .iter()
                    .zip(entries.iter().skip(1))
                    .filter(|(l, r)| {
                        l.file_name().to_ascii_lowercase() == r.file_name().to_ascii_lowercase()
                    })
                    .map(|(l, r)| {
                        CheckError::CaseSensitiveDuplicate {
                            relative_shard_path: relative_shard_path.clone(),
                            first: l.file_name(),
                            second: r.file_name(),
                        }
                        .into_result::<()>()
                    });

                let duplicate_check_result = flatten_check_results(duplicate_check_results, |_| ());

                write_check_result(error_writer, duplicate_check_result)?;

                let check_results = entries.into_iter().map(|package_entry| {
                    let package_path = package_entry.path();
                    let package_name = package_entry.file_name().to_string_lossy().into_owned();
                    let relative_package_dir =
                        PathBuf::from(format!("{BASE_SUBPATH}/{shard_name}/{package_name}"));

                    if !package_path.is_dir() {
                        CheckError::PackageNonDir {
                            relative_package_dir: relative_package_dir.clone(),
                        }
                        .into_result()
                    } else {
                        let package_name_valid = PACKAGE_NAME_REGEX.is_match(&package_name);
                        let name_check_result = if !package_name_valid {
                            CheckError::InvalidPackageName {
                                relative_package_dir: relative_package_dir.clone(),
                                package_name: package_name.clone(),
                            }
                            .into_result()
                        } else {
                            pass(())
                        };

                        let correct_relative_package_dir =
                            Nixpkgs::relative_dir_for_package(&package_name);
                        let shard_check_result =
                            if relative_package_dir != correct_relative_package_dir {
                                // Only show this error if we have a valid shard and package name
                                // Because if one of those is wrong, you should fix that first
                                if shard_name_valid && package_name_valid {
                                    CheckError::IncorrectShard {
                                        relative_package_dir: relative_package_dir.clone(),
                                        correct_relative_package_dir: correct_relative_package_dir
                                            .clone(),
                                    }
                                    .into_result()
                                } else {
                                    pass(())
                                }
                            } else {
                                pass(())
                            };

                        let package_nix_path = package_path.join(PACKAGE_NIX_FILENAME);
                        let package_nix_check_result = if !package_nix_path.exists() {
                            CheckError::PackageNixNonExistent {
                                relative_package_dir: relative_package_dir.clone(),
                            }
                            .into_result()
                        } else if package_nix_path.is_dir() {
                            CheckError::PackageNixDir {
                                relative_package_dir: relative_package_dir.clone(),
                            }
                            .into_result()
                        } else {
                            pass(())
                        };

                        flatten_check_results(
                            [
                                name_check_result,
                                shard_check_result,
                                package_nix_check_result,
                            ],
                            |_| package_name.clone(),
                        )
                    }
                });

                flatten_check_results(check_results, |x| x)
            };

            if let Some(shard_package_names) = write_check_result(error_writer, check_result)? {
                package_names.extend(shard_package_names)
            }
        }

        Ok(Nixpkgs {
            path: path.to_owned(),
            package_names,
        })
    }
}
