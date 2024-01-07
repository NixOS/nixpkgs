//! This module implements the ratchet checks, see ../README.md#ratchet-checks
//!
//! Each type has a `compare` method that validates the ratchet checks for that item.

use crate::nixpkgs_problem::NixpkgsProblem;
use crate::structure;
use crate::validation::{self, Validation, Validation::Success};
use std::collections::HashMap;

/// The ratchet value for the entirety of Nixpkgs.
#[derive(Default)]
pub struct Nixpkgs {
    /// The ratchet values for each package in `pkgs/by-name`
    pub packages: HashMap<String, Package>,
}

impl Nixpkgs {
    /// Validates the ratchet checks for Nixpkgs
    pub fn compare(optional_from: Option<Self>, to: Self) -> Validation<()> {
        validation::sequence_(
            // We only loop over the current attributes,
            // we don't need to check ones that were removed
            to.packages.into_iter().map(|(name, attr_to)| {
                let attr_from = if let Some(from) = &optional_from {
                    from.packages.get(&name)
                } else {
                    // This pretends that if there's no base version to compare against, all
                    // attributes existed without conforming to the new strictness check for
                    // backwards compatibility.
                    // TODO: Remove this case. This is only needed because the `--base`
                    // argument is still optional, which doesn't need to be once CI is updated
                    // to pass it.
                    Some(&Package {
                        empty_non_auto_called: EmptyNonAutoCalled::Invalid,
                    })
                };
                Package::compare(&name, attr_from, &attr_to)
            }),
        )
    }
}

/// The ratchet value for a single package in `pkgs/by-name`
pub struct Package {
    /// The ratchet value for the check for non-auto-called empty arguments
    pub empty_non_auto_called: EmptyNonAutoCalled,
}

impl Package {
    /// Validates the ratchet checks for a single package defined in `pkgs/by-name`
    pub fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        EmptyNonAutoCalled::compare(
            name,
            optional_from.map(|x| &x.empty_non_auto_called),
            &to.empty_non_auto_called,
        )
    }
}

/// The ratchet value of a single package in `pkgs/by-name`
/// for the non-auto-called empty argument check of a single.
///
/// This checks that packages defined in `pkgs/by-name` cannot be overridden
/// with an empty second argument like `callPackage ... { }`.
#[derive(PartialEq, PartialOrd)]
pub enum EmptyNonAutoCalled {
    Invalid,
    Valid,
}

impl EmptyNonAutoCalled {
    /// Validates the non-auto-called empty argument ratchet check for a single package defined in `pkgs/by-name`
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
