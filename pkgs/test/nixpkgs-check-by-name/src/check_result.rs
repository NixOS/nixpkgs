use crate::utils::PACKAGE_NIX_FILENAME;
use crate::ErrorWriter;
use itertools::{Either, Itertools};
use rnix::parser::ParseError;
use std::ffi::OsString;
use std::fmt;
use std::io;
use std::path::PathBuf;

pub enum CheckError {
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

impl CheckError {
    pub fn into_result<A>(self) -> CheckResult<A> {
        Ok(Either::Left(vec![self]))
    }
}

impl fmt::Display for CheckError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            CheckError::PackageNonDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: This path is a file, but it should be a directory.",
                    relative_package_dir.display(),
                ),
            CheckError::CaseSensitiveDuplicate { relative_shard_path, first, second } =>
                write!(
                    f,
                    "{}: Duplicate case-sensitive package directories {first:?} and {second:?}.",
                    relative_shard_path.display(),
                ),
            CheckError::InvalidPackageName { relative_package_dir, package_name } =>
                write!(
                    f,
                    "{}: Invalid package directory name \"{package_name}\", must be ASCII characters consisting of a-z, A-Z, 0-9, \"-\" or \"_\".",
                    relative_package_dir.display(),
                ),
            CheckError::IncorrectShard { relative_package_dir, correct_relative_package_dir } =>
                write!(
                    f,
                    "{}: Incorrect directory location, should be {} instead.",
                    relative_package_dir.display(),
                    correct_relative_package_dir.display(),
                ),
            CheckError::PackageNixNonExistent { relative_package_dir } =>
                write!(
                    f,
                    "{}: Missing required \"{PACKAGE_NIX_FILENAME}\" file.",
                    relative_package_dir.display(),
                ),
            CheckError::PackageNixDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: \"{PACKAGE_NIX_FILENAME}\" must be a file.",
                    relative_package_dir.display(),
                ),
            CheckError::UndefinedAttr { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute is not defined but it should be defined automatically as {}",
                    relative_package_file.display()
                ),
            CheckError::WrongCallPackage { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute is manually defined (most likely in pkgs/top-level/all-packages.nix), which is only allowed if the definition is of the form `pkgs.callPackage {} {{ ... }}` with a non-empty second argument.",
                    relative_package_file.display()
                ),
            CheckError::NonDerivation { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute defined by {} is not a derivation",
                    relative_package_file.display()
                ),
            CheckError::OutsideSymlink { relative_package_dir, subpath } =>
                write!(
                    f,
                    "{}: Path {} is a symlink pointing to a path outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                ),
            CheckError::UnresolvableSymlink { relative_package_dir, subpath, io_error } =>
                write!(
                    f,
                    "{}: Path {} is a symlink which cannot be resolved: {io_error}.",
                    relative_package_dir.display(),
                    subpath.display(),
                ),
            CheckError::CouldNotParseNix { relative_package_dir, subpath, error } =>
                write!(
                    f,
                    "{}: File {} could not be parsed by rnix: {}",
                    relative_package_dir.display(),
                    subpath.display(),
                    error,
                ),
            CheckError::PathInterpolation { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\", which is not yet supported and may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text
                ),
            CheckError::SearchPath { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the nix search path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text
                ),
            CheckError::OutsidePathReference { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text,
                ),
            CheckError::UnresolvablePathReference { relative_package_dir, subpath, line, text, io_error } =>
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

pub fn write_check_result<A, W: io::Write>(
    error_writer: &mut ErrorWriter<W>,
    check_result: CheckResult<A>,
) -> anyhow::Result<Option<A>> {
    match check_result? {
        Either::Left(errors) => {
            for error in errors {
                error_writer.write(&error.to_string())?
            }
            Ok(None)
        }
        Either::Right(value) => Ok(Some(value)),
    }
}

pub fn pass<A>(value: A) -> CheckResult<A> {
    Ok(Either::Right(value))
}

pub type CheckResult<A> = anyhow::Result<Either<Vec<CheckError>, A>>;

pub fn flatten_check_results<I, O>(
    check_results: impl IntoIterator<Item = CheckResult<I>>,
    value_transform: impl Fn(Vec<I>) -> O,
) -> CheckResult<O> {
    let (errors, values): (Vec<_>, Vec<_>) = check_results
        .into_iter()
        .collect::<anyhow::Result<Vec<_>>>()?
        .into_iter()
        .partition_map(|r| r);

    // To combine the errors from the results we flatten all the error Vec's into a new Vec
    // This is not very efficient, but doesn't matter because generally we should have no errors
    let flattened_errors = errors.into_iter().flatten().collect::<Vec<_>>();

    if flattened_errors.is_empty() {
        Ok(Either::Right(value_transform(values)))
    } else {
        Ok(Either::Left(flattened_errors))
    }
}
