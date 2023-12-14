use crate::nixpkgs_problem::NixpkgsProblem;
use crate::structure;
use crate::validation::{self, Validation, Validation::Success};
use std::collections::HashMap;

/// The check version conformity of a Nixpkgs path:
/// When the strictness of the check increases, this structure should be extended to distinguish
/// between parts that are still valid, and ones that aren't valid anymore.
#[derive(Default)]
pub struct Nixpkgs {
    /// The package attributes tracked in `pkgs/by-name`
    pub attributes: HashMap<String, Attribute>,
}

impl Nixpkgs {
    /// Compares two Nixpkgs versions against each other, returning validation errors only if the
    /// `from` version satisfied the stricter checks, while the `to` version doesn't satisfy them
    /// anymore.
    pub fn compare(optional_from: Option<Self>, to: Self) -> Validation<()> {
        validation::sequence_(
            // We only loop over the current attributes,
            // we don't need to check ones that were removed
            to.attributes.into_iter().map(|(name, attr_to)| {
                let attr_from = if let Some(from) = &optional_from {
                    from.attributes.get(&name)
                } else {
                    // This pretends that if there's no base version to compare against, all
                    // attributes existed without conforming to the new strictness check for
                    // backwards compatibility.
                    // TODO: Remove this case. This is only needed because the `--base`
                    // argument is still optional, which doesn't need to be once CI is updated
                    // to pass it.
                    Some(&Attribute {
                        empty_non_auto_called: EmptyNonAutoCalled::Invalid,
                    })
                };
                Attribute::compare(&name, attr_from, &attr_to)
            }),
        )
    }
}

/// The check version conformity of an attribute defined by `pkgs/by-name`
pub struct Attribute {
    pub empty_non_auto_called: EmptyNonAutoCalled,
}

impl Attribute {
    pub fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        EmptyNonAutoCalled::compare(
            name,
            optional_from.map(|x| &x.empty_non_auto_called),
            &to.empty_non_auto_called,
        )
    }
}

/// Whether an attribute conforms to the new strictness check that
/// `callPackage ... {}` is not allowed anymore in `all-package.nix`
#[derive(PartialEq, PartialOrd)]
pub enum EmptyNonAutoCalled {
    /// The attribute is not valid anymore with the new check
    Invalid,
    /// The attribute is still valid with the new check
    Valid,
}

impl EmptyNonAutoCalled {
    fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        let from = optional_from.unwrap_or(&Self::Valid);
        if to >= from {
            Success(())
        } else {
            NixpkgsProblem::WrongCallPackage {
                relative_package_file: structure::relative_file_for_package(name),
                package_name: name.to_owned(),
            }
            .into()
        }
    }
}
