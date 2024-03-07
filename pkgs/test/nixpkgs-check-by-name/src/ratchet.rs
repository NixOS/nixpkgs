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
    /// Sorted list of attributes in package_map
    pub package_names: Vec<String>,
    /// The ratchet values for all packages
    pub package_map: HashMap<String, Package>,
}

impl Nixpkgs {
    /// Validates the ratchet checks for Nixpkgs
    pub fn compare(from: Self, to: Self) -> Validation<()> {
        validation::sequence_(
            // We only loop over the current attributes,
            // we don't need to check ones that were removed
            to.package_names.into_iter().map(|name| {
                Package::compare(&name, from.package_map.get(&name), &to.package_map[&name])
            }),
        )
    }
}

/// The ratchet value for a single package in `pkgs/by-name`
pub struct Package {
    /// The ratchet value for the check for non-auto-called empty arguments
    pub empty_non_auto_called: RatchetState<EmptyNonAutoCalled>,
}

impl Package {
    /// Validates the ratchet checks for a single package defined in `pkgs/by-name`
    pub fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        RatchetState::<EmptyNonAutoCalled>::compare(
            name,
            optional_from.map(|x| &x.empty_non_auto_called),
            &to.empty_non_auto_called,
        )
    }
}

/// The ratchet state of a generic ratchet check.
pub enum RatchetState<Context> {
    /// The ratchet is loose, it can be tightened more.
    /// In other words, this is the legacy state we're trying to move away from.
    /// Introducing new instances is not allowed but previous instances will continue to be allowed.
    /// The `Context` is context for error messages in case a new instance of this state is
    /// introduced
    Loose(Context),
    /// The ratchet is tight, it can't be tightened any further.
    /// This is either because we already use the latest state, or because the ratchet isn't
    /// relevant.
    Tight,
}

/// A trait that can convert an attribute-specific error context into a NixpkgsProblem
pub trait ToNixpkgsProblem {
    /// How to convert an attribute-specific error context into a NixpkgsProblem
    fn to_nixpkgs_problem(name: &str, context: &Self, existed_before: bool) -> NixpkgsProblem;
}

impl<Context: ToNixpkgsProblem> RatchetState<Context> {
    /// Compare the previous ratchet state of an attribute to the new state.
    /// The previous state may be `None` in case the attribute is new.
    fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        // If we don't have a previous state, enforce a tight ratchet
        let from = optional_from.unwrap_or(&RatchetState::Tight);
        match (from, to) {
            // Always okay to keep it tight or tighten the ratchet
            (_, RatchetState::Tight) => Success(()),

            // Grandfathering policy for a loose ratchet
            (RatchetState::Loose { .. }, RatchetState::Loose { .. }) => Success(()),

            // Loosening a ratchet is now allowed
            (RatchetState::Tight, RatchetState::Loose(context)) => {
                Context::to_nixpkgs_problem(name, context, optional_from.is_some()).into()
            }
        }
    }
}

/// The ratchet value of an attribute
/// for the non-auto-called empty argument check of a single.
///
/// This checks that packages defined in `pkgs/by-name` cannot be overridden
/// with an empty second argument like `callPackage ... { }`.
pub struct EmptyNonAutoCalled;

impl ToNixpkgsProblem for EmptyNonAutoCalled {
    fn to_nixpkgs_problem(name: &str, _context: &Self, _existed_before: bool) -> NixpkgsProblem {
        NixpkgsProblem::WrongCallPackage {
            relative_package_file: structure::relative_file_for_package(name),
            package_name: name.to_owned(),
        }
    }
}
