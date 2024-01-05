//! This module implements the ratchet checks, see ../README.md#ratchet-checks
//!
//! Each type has a `compare` method that validates the ratchet checks for that item.

use crate::nixpkgs_problem::NixpkgsProblem;
use crate::structure;
use crate::validation::{self, Validation, Validation::Success};
use std::collections::HashMap;
use std::path::PathBuf;

/// The ratchet value for the entirety of Nixpkgs.
#[derive(Default)]
pub struct Nixpkgs {
    /// Sorted list of packages in package_map
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

/// The ratchet value for a top-level package
pub struct Package {
    /// The ratchet value for the check for non-auto-called empty arguments
    pub empty_non_auto_called: RatchetState<EmptyNonAutoCalled>,

    /// The ratchet value for the check for new packages using pkgs/by-name
    pub uses_by_name: RatchetState<UsesByName>,
}

impl Package {
    /// Validates the ratchet checks for a top-level package
    pub fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        validation::sequence_([
            RatchetState::<EmptyNonAutoCalled>::compare(
                name,
                optional_from.map(|x| &x.empty_non_auto_called),
                &to.empty_non_auto_called,
            ),
            RatchetState::<UsesByName>::compare(
                name,
                optional_from.map(|x| &x.uses_by_name),
                &to.uses_by_name,
            ),
        ])
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

/// The ratchet value of an attribute
/// for the check that new packages use pkgs/by-name
///
/// This checks that all new package defined using callPackage must be defined via pkgs/by-name
/// It also checks that once a package uses pkgs/by-name, it can't switch back to all-packages.nix
#[derive(Clone)]
pub struct UsesByName {
    /// The first callPackage argument, used for better errors
    pub call_package_path: Option<PathBuf>,
    /// Whether the second callPackage argument is empty, used for better errors
    pub empty_arg: bool,
}

impl ToNixpkgsProblem for UsesByName {
    fn to_nixpkgs_problem(name: &str, a: &Self, existed_before: bool) -> NixpkgsProblem {
        if existed_before {
            NixpkgsProblem::MovedOutOfByName {
                package_name: name.to_owned(),
                call_package_path: a.call_package_path.clone(),
                empty_arg: a.empty_arg,
            }
        } else {
            NixpkgsProblem::NewPackageNotUsingByName {
                package_name: name.to_owned(),
                call_package_path: a.call_package_path.clone(),
                empty_arg: a.empty_arg,
            }
        }
    }
}
