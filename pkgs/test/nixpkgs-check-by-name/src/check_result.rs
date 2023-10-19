use crate::ErrorWriter;
use itertools::{Either, Itertools};
use std::fmt;
use std::io;
use std::path::PathBuf;

pub enum CheckError {
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
