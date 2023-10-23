use crate::nixpkgs_problem::NixpkgsProblem;
use itertools::concat;
use itertools::{
    Either,
    Either::{Left, Right},
    Itertools,
};

/// A type alias representing the result of a check, either:
/// - Err(anyhow::Error): A fatal failure, typically I/O errors.
///   Such failures are not caused by the files in Nixpkgs.
///   This hints at a bug in the code or a problem with the deployment.
/// - Ok(Left(Vec<NixpkgsProblem>)): A non-fatal problem with the Nixpkgs files.
///   Further checks can be run even with this result type.
///   Such problems can be fixed by changing the Nixpkgs files.
/// - Ok(Right(A)): A successful (potentially intermediate) result with an arbitrary value.
///   No fatal errors have occurred and no problems have been found with Nixpkgs.
pub type CheckResult<A> = anyhow::Result<Either<Vec<NixpkgsProblem>, A>>;

/// Map a `CheckResult<I>` to a `CheckResult<O>` by applying a function to the
/// potentially contained value in case of success.
pub fn map<I, O>(check_result: CheckResult<I>, f: impl FnOnce(I) -> O) -> CheckResult<O> {
    Ok(check_result?.map_right(f))
}

/// Create a successfull `CheckResult<A>` from a value `A`.
pub fn ok<A>(value: A) -> CheckResult<A> {
    Ok(Right(value))
}

impl NixpkgsProblem {
    /// Create a `CheckResult<A>` from a single check problem
    pub fn into_result<A>(self) -> CheckResult<A> {
        Ok(Left(vec![self]))
    }
}

/// Combine two check results, both of which need to be successful for the return value to be successful.
/// The `NixpkgsProblem`s of both sides are returned concatenated.
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
/// The `NixpkgsProblem`s of all results are returned concatenated.
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
