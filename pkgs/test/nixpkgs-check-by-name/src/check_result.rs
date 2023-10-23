use crate::utils::PACKAGE_NIX_FILENAME;
use itertools::concat;
use itertools::{
    Either,
    Either::{Left, Right},
    Itertools,
};
use rnix::parser::ParseError;
use std::ffi::OsString;
use std::fmt;
use std::io;
use std::path::PathBuf;

pub enum CheckProblem {
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

impl CheckProblem {
    pub fn into_result<A>(self) -> CheckResult<A> {
        Ok(Left(vec![self]))
    }
}

impl fmt::Display for CheckProblem {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            CheckProblem::ShardNonDir { relative_shard_path } =>
                write!(
                    f,
                    "{}: This is a file, but it should be a directory.",
                    relative_shard_path.display(),
                ),
            CheckProblem::InvalidShardName { relative_shard_path, shard_name } =>
                write!(
                    f,
                    "{}: Invalid directory name \"{shard_name}\", must be at most 2 ASCII characters consisting of a-z, 0-9, \"-\" or \"_\".",
                    relative_shard_path.display()
                ),
            CheckProblem::PackageNonDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: This path is a file, but it should be a directory.",
                    relative_package_dir.display(),
                ),
            CheckProblem::CaseSensitiveDuplicate { relative_shard_path, first, second } =>
                write!(
                    f,
                    "{}: Duplicate case-sensitive package directories {first:?} and {second:?}.",
                    relative_shard_path.display(),
                ),
            CheckProblem::InvalidPackageName { relative_package_dir, package_name } =>
                write!(
                    f,
                    "{}: Invalid package directory name \"{package_name}\", must be ASCII characters consisting of a-z, A-Z, 0-9, \"-\" or \"_\".",
                    relative_package_dir.display(),
                ),
            CheckProblem::IncorrectShard { relative_package_dir, correct_relative_package_dir } =>
                write!(
                    f,
                    "{}: Incorrect directory location, should be {} instead.",
                    relative_package_dir.display(),
                    correct_relative_package_dir.display(),
                ),
            CheckProblem::PackageNixNonExistent { relative_package_dir } =>
                write!(
                    f,
                    "{}: Missing required \"{PACKAGE_NIX_FILENAME}\" file.",
                    relative_package_dir.display(),
                ),
            CheckProblem::PackageNixDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: \"{PACKAGE_NIX_FILENAME}\" must be a file.",
                    relative_package_dir.display(),
                ),
            CheckProblem::UndefinedAttr { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute is not defined but it should be defined automatically as {}",
                    relative_package_file.display()
                ),
            CheckProblem::WrongCallPackage { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute is manually defined (most likely in pkgs/top-level/all-packages.nix), which is only allowed if the definition is of the form `pkgs.callPackage {} {{ ... }}` with a non-empty second argument.",
                    relative_package_file.display()
                ),
            CheckProblem::NonDerivation { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute defined by {} is not a derivation",
                    relative_package_file.display()
                ),
            CheckProblem::OutsideSymlink { relative_package_dir, subpath } =>
                write!(
                    f,
                    "{}: Path {} is a symlink pointing to a path outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                ),
            CheckProblem::UnresolvableSymlink { relative_package_dir, subpath, io_error } =>
                write!(
                    f,
                    "{}: Path {} is a symlink which cannot be resolved: {io_error}.",
                    relative_package_dir.display(),
                    subpath.display(),
                ),
            CheckProblem::CouldNotParseNix { relative_package_dir, subpath, error } =>
                write!(
                    f,
                    "{}: File {} could not be parsed by rnix: {}",
                    relative_package_dir.display(),
                    subpath.display(),
                    error,
                ),
            CheckProblem::PathInterpolation { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\", which is not yet supported and may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text
                ),
            CheckProblem::SearchPath { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the nix search path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text
                ),
            CheckProblem::OutsidePathReference { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir.display(),
                    subpath.display(),
                    text,
                ),
            CheckProblem::UnresolvablePathReference { relative_package_dir, subpath, line, text, io_error } =>
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

/// A type alias representing the result of a check, either:
/// - Err(anyhow::Error): A fatal failure, typically I/O errors.
///   Such failures are not caused by the files in Nixpkgs.
///   This hints at a bug in the code or a problem with the deployment.
/// - Ok(Left(Vec<CheckProblem>)): A non-fatal problem with the Nixpkgs files.
///   Further checks can be run even with this result type.
///   Such problems can be fixed by changing the Nixpkgs files.
/// - Ok(Right(A)): A successful (potentially intermediate) result with an arbitrary value.
///   No fatal errors have occurred and no problems have been found with Nixpkgs.
pub type CheckResult<A> = anyhow::Result<Either<Vec<CheckProblem>, A>>;

/// Map a `CheckResult<I>` to a `CheckResult<O>` by applying a function to the
/// potentially contained value in case of success.
pub fn map<I, O>(check_result: CheckResult<I>, f: impl FnOnce(I) -> O) -> CheckResult<O> {
    Ok(check_result?.map_right(f))
}

/// Create a successfull `CheckResult<A>` from a value `A`.
pub fn ok<A>(value: A) -> CheckResult<A> {
    Ok(Right(value))
}

/// Combine two check results, both of which need to be successful for the return value to be successful.
/// The `CheckProblem`s of both sides are returned concatenated.
pub fn and<A>(first: CheckResult<()>, second: CheckResult<A>) -> CheckResult<A> {
    match (first?, second?) {
        (Right(_), Right(right_value)) => Ok(Right(right_value)),
        (Left(errors), Right(_)) => Ok(Left(errors)),
        (Right(_), Left(errors)) => Ok(Left(errors)),
        (Left(errors_l), Left(errors_r)) => Ok(Left(concat([errors_l, errors_r]))),
    }
}

/// Combine many checks results into a single one.
/// All given check results need to be successful in order for the returned check result to be successful,
/// in which case the returned check result value contains each a `Vec` of each individual result value.
/// The `CheckProblem`s of all results are returned concatenated.
pub fn sequence<A>(check_results: impl IntoIterator<Item = CheckResult<A>>) -> CheckResult<Vec<A>> {
    let (errors, values): (Vec<_>, Vec<_>) = check_results
        .into_iter()
        .collect::<anyhow::Result<Vec<_>>>()?
        .into_iter()
        .partition_map(|r| r);

    // To combine the errors from the results we flatten all the error Vec's into a new Vec
    // This is not very efficient, but doesn't matter because generally we should have no errors
    let flattened_errors = errors.into_iter().flatten().collect::<Vec<_>>();

    if flattened_errors.is_empty() {
        Ok(Right(values))
    } else {
        Ok(Left(flattened_errors))
    }
}

/// Like `sequence`, but replace the resulting value with ()
pub fn sequence_<A>(check_results: impl IntoIterator<Item = CheckResult<A>>) -> CheckResult<()> {
    map(sequence(check_results), |_| ())
}
