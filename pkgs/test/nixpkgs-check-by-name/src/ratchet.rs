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
    pub empty_non_auto_called: RatchetState<EmptyNonAutoCalled>,
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

/// The ratchet state of a generic ratchet check.
pub enum RatchetState<Context> {
    /// The ratchet is loose, it can be tightened more.
    /// In other words, this is the legacy state we're trying to move away from.
    /// Introducing new instances is now allowed but previous instances will continue to be allowed.
    /// The `Context` is context for error messages in case a new instance of this state is
    /// introduced
    Loose(Context),
    /// The ratchet is tight, it can't be tightened any further.
    /// This is either because we already use the latest state, or because the ratchet isn't
    /// relevant.
    Tight,
}

/// A trait for a specific ratchet check for an attribute.
trait AttributeRatchet: Sized {
    /// What error to produce in case the ratchet went in the wrong direction
    fn to_error(name: &str, context: &Self, existed_before: bool) -> NixpkgsProblem;

    /// Compare the previous ratchet state of an attribute to the new state.
    /// The previous state may be `None` in case the attribute is new.
    fn compare(
        name: &str,
        optional_from: Option<&RatchetState<Self>>,
        to: &RatchetState<Self>,
    ) -> Validation<()> {
        // If we don't have a previous state, enforce a tight ratchet
        let from = optional_from.unwrap_or(&RatchetState::Tight);
        match (from, to) {
            // Always okay to keep it tight or tighten the ratchet
            (_, RatchetState::Tight) => Success(()),

            // Grandfathering policy for a loose ratchet
            (RatchetState::Loose { .. }, RatchetState::Loose { .. }) => Success(()),

            // Loosening a ratchet is now allowed
            (RatchetState::Tight, RatchetState::Loose(context)) => {
                Self::to_error(name, context, optional_from.is_some()).into()
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

impl AttributeRatchet for EmptyNonAutoCalled {
    fn to_error(name: &str, _context: &Self, _existed_before: bool) -> NixpkgsProblem {
        NixpkgsProblem::WrongCallPackage {
            relative_package_file: structure::relative_file_for_package(name),
            package_name: name.to_owned(),
        }
    }
}
