use crate::utils::PACKAGE_NIX_FILENAME;
use rnix::parser::ParseError;
use std::ffi::OsString;
use std::fmt;
use std::io;
use std::path::PathBuf;

/// Any problem that can occur when checking Nixpkgs
pub enum NixpkgsProblem {
    ShardNonDir {
        relative_shard_path: PathBuf,
    },
    InvalidShardName {
        relative_shard_path: PathBuf,
        shard_name: String,
    },
    PackageNonDir {
        relative_package_dir: PathBuf,
    },
    CaseSensitiveDuplicate {
        relative_shard_path: PathBuf,
        first: OsString,
        second: OsString,
    },
    InvalidPackageName {
        relative_package_dir: PathBuf,
        package_name: String,
    },
    IncorrectShard {
        relative_package_dir: PathBuf,
        correct_relative_package_dir: PathBuf,
    },
    PackageNixNonExistent {
        relative_package_dir: PathBuf,
    },
    PackageNixDir {
        relative_package_dir: PathBuf,
    },
    UndefinedAttr {
        relative_package_file: PathBuf,
        package_name: String,
    },
    WrongCallPackage {
        relative_package_file: PathBuf,
        package_name: String,
    },
    NonDerivation {
        relative_package_file: PathBuf,
        package_name: String,
    },
    OutsideSymlink {
        relative_package_dir: PathBuf,
        subpath: PathBuf,
    },
    UnresolvableSymlink {
        relative_package_dir: PathBuf,
        subpath: PathBuf,
        io_error: io::Error,
    },
    CouldNotParseNix {
        relative_package_dir: PathBuf,
        subpath: PathBuf,
        error: ParseError,
    },
    PathInterpolation {
        relative_package_dir: PathBuf,
        subpath: PathBuf,
        line: usize,
        text: String,
    },
    SearchPath {
        relative_package_dir: PathBuf,
        subpath: PathBuf,
        line: usize,
        text: String,
    },
    OutsidePathReference {
        relative_package_dir: PathBuf,
        subpath: PathBuf,
        line: usize,
        text: String,
    },
    UnresolvablePathReference {
        relative_package_dir: PathBuf,
        subpath: PathBuf,
        line: usize,
        text: String,
        io_error: io::Error,
    },
}

impl fmt::Display for NixpkgsProblem {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            NixpkgsProblem::ShardNonDir { relative_shard_path } =>
                write!(
                    f,
                    "{}: This is a file, but it should be a directory.",
                    relative_shard_path.display(),
                ),
            NixpkgsProblem::InvalidShardName { relative_shard_path, shard_name } =>
                write!(
                    f,
                    "{}: Invalid directory name \"{shard_name}\", must be at most 2 ASCII characters consisting of a-z, 0-9, \"-\" or \"_\".",
                    relative_shard_path.display()
                ),
            NixpkgsProblem::PackageNonDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: This path is a file, but it should be a directory.",
                    relative_package_dir.display(),
                ),
            NixpkgsProblem::CaseSensitiveDuplicate { relative_shard_path, first, second } =>
                write!(
                    f,
                    "{}: Duplicate case-sensitive package directories {first:?} and {second:?}.",
                    relative_shard_path.display(),
                ),
            NixpkgsProblem::InvalidPackageName { relative_package_dir, package_name } =>
                write!(
                    f,
                    "{}: Invalid package directory name \"{package_name}\", must be ASCII characters consisting of a-z, A-Z, 0-9, \"-\" or \"_\".",
                    relative_package_dir.display(),
                ),
            NixpkgsProblem::IncorrectShard { relative_package_dir, correct_relative_package_dir } =>
                write!(
                    f,
                    "{}: Incorrect directory location, should be {} instead.",
                    relative_package_dir.display(),
                    correct_relative_package_dir.display(),
                ),
            NixpkgsProblem::PackageNixNonExistent { relative_package_dir } =>
                write!(
                    f,
                    "{}: Missing required \"{PACKAGE_NIX_FILENAME}\" file.",
                    relative_package_dir.display(),
                ),
            NixpkgsProblem::PackageNixDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: \"{PACKAGE_NIX_FILENAME}\" must be a file.",
                    relative_package_dir.display(),
                ),
            NixpkgsProblem::UndefinedAttr { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute is not defined but it should be defined automatically as {}",
                    relative_package_file.display()
                ),
            NixpkgsProblem::WrongCallPackage { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute is manually defined (most likely in pkgs/top-level/all-packages.nix), which is only allowed if the definition is of the form `pkgs.callPackage {} {{ ... }}` with a non-empty second argument.",
                    relative_package_file.display()
                ),
            NixpkgsProblem::NonDerivation { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute defined by {} is not a derivation",
                    relative_package_file.display()
                ),
            NixpkgsProblem::OutsideSymlink { relative_package_dir, subpath } =>
                write!(
                    f,
                    "{}: Path {} is a symlink pointing to a path outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                ),
            NixpkgsProblem::UnresolvableSymlink { relative_package_dir, subpath, io_error } =>
                write!(
                    f,
                    "{}: Path {} is a symlink which cannot be resolved: {io_error}.",
                    relative_package_dir.display(),
                    subpath.display(),
                ),
            NixpkgsProblem::CouldNotParseNix { relative_package_dir, subpath, error } =>
                write!(
                    f,
                    "{}: File {} could not be parsed by rnix: {}",
                    relative_package_dir.display(),
                    subpath.display(),
                    error,
                ),
            NixpkgsProblem::PathInterpolation { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\", which is not yet supported and may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text
                ),
            NixpkgsProblem::SearchPath { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the nix search path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text
                ),
            NixpkgsProblem::OutsidePathReference { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text,
                ),
            NixpkgsProblem::UnresolvablePathReference { relative_package_dir, subpath, line, text, io_error } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\" which cannot be resolved: {io_error}.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text,
                ),
        }
    }
}
