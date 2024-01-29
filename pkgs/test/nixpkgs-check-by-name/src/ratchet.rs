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
    pub manual_definition: RatchetState<ManualDefinition>,

    /// The ratchet value for the check for new packages using pkgs/by-name
    pub uses_by_name: RatchetState<UsesByName>,
}

impl Package {
    /// Validates the ratchet checks for a top-level package
    pub fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        validation::sequence_([
            RatchetState::<ManualDefinition>::compare(
                name,
                optional_from.map(|x| &x.manual_definition),
                &to.manual_definition,
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
pub enum RatchetState<Ratchet: ToNixpkgsProblem> {
    /// The ratchet is loose, it can be tightened more.
    /// In other words, this is the legacy state we're trying to move away from.
    /// Introducing new instances is not allowed but previous instances will continue to be allowed.
    /// The `Context` is context for error messages in case a new instance of this state is
    /// introduced
    Loose(Ratchet::ToContext),
    /// The ratchet is tight, it can't be tightened any further.
    /// This is either because we already use the latest state, or because the ratchet isn't
    /// relevant.
    Tight,
    /// This ratchet can't be applied.
    /// State transitions from/to NonApplicable are always allowed
    NonApplicable,
}

/// A trait that can convert an attribute-specific error context into a NixpkgsProblem
pub trait ToNixpkgsProblem {
    /// Context relating to the Nixpkgs that is being transitioned _to_
    type ToContext;

    /// How to convert an attribute-specific error context into a NixpkgsProblem
    fn to_nixpkgs_problem(
        name: &str,
        optional_from: Option<()>,
        to: &Self::ToContext,
    ) -> NixpkgsProblem;
}

impl<Context: ToNixpkgsProblem> RatchetState<Context> {
    /// Compare the previous ratchet state of an attribute to the new state.
    /// The previous state may be `None` in case the attribute is new.
    fn compare(name: &str, optional_from: Option<&Self>, to: &Self) -> Validation<()> {
        match (optional_from, to) {
            // Loosening a ratchet is now allowed
            (Some(RatchetState::Tight), RatchetState::Loose(loose_context)) => {
                Context::to_nixpkgs_problem(name, Some(()), loose_context).into()
            }

            // Introducing a loose ratchet is also not allowed
            (None, RatchetState::Loose(loose_context)) => {
                Context::to_nixpkgs_problem(name, None, loose_context).into()
            }

            // Everything else is allowed, including:
            // - Loose -> Loose (grandfathering policy for a loose ratchet)
            // - -> Tight (always okay to keep or make the ratchet tight)
            // - Anything involving NotApplicable, where we can't really make any good calls
            _ => Success(()),
        }
    }
}

/// The ratchet to check whether a top-level attribute has/needs
/// a manual definition, e.g. in all-packages.nix.
///
/// This ratchet is only tight for attributes that:
/// - Are not defined in `pkgs/by-name`, and rely on a manual definition
/// - Are defined in `pkgs/by-name` without any manual definition,
///   (no custom argument overrides)
/// - Are defined with `pkgs/by-name` with a manual definition that can't be removed
///   because it provides custom argument overrides
///
/// In comparison, this ratchet is loose for attributes that:
/// - Are defined in `pkgs/by-name` with a manual definition
///   that doesn't have any custom argument overrides
pub enum ManualDefinition {}

impl ToNixpkgsProblem for ManualDefinition {
    type ToContext = ();

    fn to_nixpkgs_problem(
        name: &str,
        _optional_from: Option<()>,
        _to: &Self::ToContext,
    ) -> NixpkgsProblem {
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
pub enum UsesByName {}

#[derive(Clone)]
pub struct CouldUseByName {
    /// The first callPackage argument, used for better errors
    pub call_package_path: Option<PathBuf>,
    /// Whether the second callPackage argument is empty, used for better errors
    pub empty_arg: bool,
}

impl ToNixpkgsProblem for UsesByName {
    type ToContext = CouldUseByName;

    fn to_nixpkgs_problem(
        name: &str,
        optional_from: Option<()>,
        to: &Self::ToContext,
    ) -> NixpkgsProblem {
        if let Some(()) = optional_from {
            NixpkgsProblem::MovedOutOfByName {
                package_name: name.to_owned(),
                call_package_path: to.call_package_path.clone(),
                empty_arg: to.empty_arg,
            }
        } else {
            NixpkgsProblem::NewPackageNotUsingByName {
                package_name: name.to_owned(),
                call_package_path: to.call_package_path.clone(),
                empty_arg: to.empty_arg,
            }
        }
    }
}
