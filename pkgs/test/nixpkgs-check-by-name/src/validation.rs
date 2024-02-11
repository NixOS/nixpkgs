use crate::nixpkgs_problem::NixpkgsProblem;
use itertools::concat;
use itertools::{
    Either::{Left, Right},
    Itertools,
};
use Validation::*;

/// The validation result of a check.
/// Instead of exiting at the first failure,
/// this type can accumulate multiple failures.
/// This can be achieved using the functions `and`, `sequence` and `sequence_`
///
/// This leans on https://hackage.haskell.org/package/validation
pub enum Validation<A> {
    Failure(Vec<NixpkgsProblem>),
    Success(A),
}

impl<A> From<NixpkgsProblem> for Validation<A> {
    /// Create a `Validation<A>` from a single check problem
    fn from(value: NixpkgsProblem) -> Self {
        Failure(vec![value])
    }
}

/// A type alias representing the result of a check, either:
/// - Err(anyhow::Error): A fatal failure, typically I/O errors.
///   Such failures are not caused by the files in Nixpkgs.
///   This hints at a bug in the code or a problem with the deployment.
/// - Ok(Failure(Vec<NixpkgsProblem>)): A non-fatal validation problem with the Nixpkgs files.
///   Further checks can be run even with this result type.
///   Such problems can be fixed by changing the Nixpkgs files.
/// - Ok(Success(A)): A successful (potentially intermediate) result with an arbitrary value.
///   No fatal errors have occurred and no validation problems have been found with Nixpkgs.
pub type Result<A> = anyhow::Result<Validation<A>>;

pub trait ResultIteratorExt<A, E>: Sized + Iterator<Item = std::result::Result<A, E>> {
    fn collect_vec(self) -> std::result::Result<Vec<A>, E>;
}

impl<I, A, E> ResultIteratorExt<A, E> for I
where
    I: Sized + Iterator<Item = std::result::Result<A, E>>,
{
    /// A convenience version of `collect` specialised to a vector
    fn collect_vec(self) -> std::result::Result<Vec<A>, E> {
        self.collect()
    }
}

impl<A> Validation<A> {
    /// Map a `Validation<A>` to a `Validation<B>` by applying a function to the
    /// potentially contained value in case of success.
    pub fn map<B>(self, f: impl FnOnce(A) -> B) -> Validation<B> {
        match self {
            Failure(err) => Failure(err),
            Success(value) => Success(f(value)),
        }
    }

    /// Map a `Validation<A>` to a `Result<B>` by applying a function `A -> Result<B>`
    /// only if there is a `Success` value
    pub fn result_map<B>(self, f: impl FnOnce(A) -> Result<B>) -> Result<B> {
        match self {
            Failure(err) => Ok(Failure(err)),
            Success(value) => f(value),
        }
    }
}

impl Validation<()> {
    /// Combine two validations, both of which need to be successful for the return value to be successful.
    /// The `NixpkgsProblem`s of both sides are returned concatenated.
    pub fn and<A>(self, other: Validation<A>) -> Validation<A> {
        match (self, other) {
            (Success(_), Success(right_value)) => Success(right_value),
            (Failure(errors), Success(_)) => Failure(errors),
            (Success(_), Failure(errors)) => Failure(errors),
            (Failure(errors_l), Failure(errors_r)) => Failure(concat([errors_l, errors_r])),
        }
    }
}

/// Combine many validations into a single one.
/// All given validations need to be successful in order for the returned validation to be successful,
/// in which case the returned validation value contains a `Vec` of each individual value.
/// Otherwise the `NixpkgsProblem`s of all validations are returned concatenated.
pub fn sequence<A>(check_results: impl IntoIterator<Item = Validation<A>>) -> Validation<Vec<A>> {
    let (errors, values): (Vec<Vec<NixpkgsProblem>>, Vec<A>) = check_results
        .into_iter()
        .partition_map(|validation| match validation {
            Failure(err) => Left(err),
            Success(value) => Right(value),
        });

    // To combine the errors from the results we flatten all the error Vec's into a new Vec
    // This is not very efficient, but doesn't matter because generally we should have no errors
    let flattened_errors = errors.into_iter().concat();

    if flattened_errors.is_empty() {
        Success(values)
    } else {
        Failure(flattened_errors)
    }
}

/// Like `sequence`, but without any containing value, for convenience
pub fn sequence_(validations: impl IntoIterator<Item = Validation<()>>) -> Validation<()> {
    sequence(validations).map(|_| ())
}
