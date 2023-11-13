use crate::utils;
use crate::utils::ErrorWriter;
use lazy_static::lazy_static;
use regex::Regex;
use std::collections::HashMap;
use std::io;
use std::path::{Path, PathBuf};

pub const BASE_SUBPATH: &str = "pkgs/by-name";
pub const PACKAGE_NIX_FILENAME: &str = "package.nix";

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

            if !shard_path.is_dir() {
                error_writer.write(&format!(
                    "{}: This is a file, but it should be a directory.",
                    relative_shard_path.display(),
                ))?;
                // we can't check for any other errors if it's a file, since there's no subdirectories to check
                continue;
            }

            let shard_name_valid = SHARD_NAME_REGEX.is_match(&shard_name);
            if !shard_name_valid {
                error_writer.write(&format!(
                    "{}: Invalid directory name \"{shard_name}\", must be at most 2 ASCII characters consisting of a-z, 0-9, \"-\" or \"_\".",
                    relative_shard_path.display()
                ))?;
            }

            let mut unique_package_names = HashMap::new();

            for package_entry in utils::read_dir_sorted(&shard_path)? {
                let package_path = package_entry.path();
                let package_name = package_entry.file_name().to_string_lossy().into_owned();
                let relative_package_dir =
                    PathBuf::from(format!("{BASE_SUBPATH}/{shard_name}/{package_name}"));

                if !package_path.is_dir() {
                    error_writer.write(&format!(
                        "{}: This path is a file, but it should be a directory.",
                        relative_package_dir.display(),
                    ))?;
                    continue;
                }

                if let Some(duplicate_package_name) =
                    unique_package_names.insert(package_name.to_lowercase(), package_name.clone())
                {
                    error_writer.write(&format!(
                        "{}: Duplicate case-sensitive package directories \"{duplicate_package_name}\" and \"{package_name}\".",
                        relative_shard_path.display(),
                    ))?;
                }

                let package_name_valid = PACKAGE_NAME_REGEX.is_match(&package_name);
                if !package_name_valid {
                    error_writer.write(&format!(
                        "{}: Invalid package directory name \"{package_name}\", must be ASCII characters consisting of a-z, A-Z, 0-9, \"-\" or \"_\".",
                        relative_package_dir.display(),
                    ))?;
                }

                let correct_relative_package_dir = Nixpkgs::relative_dir_for_package(&package_name);
                if relative_package_dir != correct_relative_package_dir {
                    // Only show this error if we have a valid shard and package name
                    // Because if one of those is wrong, you should fix that first
                    if shard_name_valid && package_name_valid {
                        error_writer.write(&format!(
                            "{}: Incorrect directory location, should be {} instead.",
                            relative_package_dir.display(),
                            correct_relative_package_dir.display(),
                        ))?;
                    }
                }

                let package_nix_path = package_path.join(PACKAGE_NIX_FILENAME);
                if !package_nix_path.exists() {
                    error_writer.write(&format!(
                        "{}: Missing required \"{PACKAGE_NIX_FILENAME}\" file.",
                        relative_package_dir.display(),
                    ))?;
                } else if package_nix_path.is_dir() {
                    error_writer.write(&format!(
                        "{}: \"{PACKAGE_NIX_FILENAME}\" must be a file.",
                        relative_package_dir.display(),
                    ))?;
                }

                package_names.push(package_name.clone());
            }
        }

        Ok(Nixpkgs {
            path: path.to_owned(),
            package_names,
        })
    }
}
