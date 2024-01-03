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
    pub fn compare(from: Self, to: Self) -> Validation<()> {
        validation::sequence_(
            // We only loop over the current attributes,
            // we don't need to check ones that were removed
            to.packages
                .into_iter()
                .map(|(name, attr_to)| Package::compare(&name, from.packages.get(&name), &attr_to)),
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
