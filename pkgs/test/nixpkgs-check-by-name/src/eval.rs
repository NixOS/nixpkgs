use crate::nix_file::CallPackageArgumentInfo;
use crate::nixpkgs_problem::NixpkgsProblem;
use crate::ratchet;
use crate::ratchet::RatchetState::Loose;
use crate::ratchet::RatchetState::Tight;
use crate::structure;
use crate::utils;
use crate::validation::ResultIteratorExt as _;
use crate::validation::{self, Validation::Success};
use crate::NixFileStore;
use relative_path::RelativePathBuf;
use std::path::Path;

use anyhow::Context;
use serde::Deserialize;
use std::path::PathBuf;
use std::process;
use tempfile::NamedTempFile;

/// Attribute set of this structure is returned by eval.nix
#[derive(Deserialize)]
enum Attribute {
    /// An attribute that should be defined via pkgs/by-name
    ByName(ByNameAttribute),
    /// An attribute not defined via pkgs/by-name
    NonByName(NonByNameAttribute),
}

#[derive(Deserialize)]
enum NonByNameAttribute {
    /// The attribute doesn't evaluate
    EvalFailure,
    EvalSuccess(AttributeInfo),
}

#[derive(Deserialize)]
enum ByNameAttribute {
    /// The attribute doesn't exist at all
    Missing,
    Existing(AttributeInfo),
}

#[derive(Deserialize)]
struct AttributeInfo {
    /// The location of the attribute as returned by `builtins.unsafeGetAttrPos`
    location: Option<Location>,
    attribute_variant: AttributeVariant,
}

/// The structure returned by a successful `builtins.unsafeGetAttrPos`
#[derive(Deserialize, Clone, Debug)]
struct Location {
    pub file: PathBuf,
    pub line: usize,
    pub column: usize,
}

impl Location {
    // Returns the [file] field, but relative to Nixpkgs
    fn relative_file(&self, nixpkgs_path: &Path) -> anyhow::Result<RelativePathBuf> {
        let path = self.file.strip_prefix(nixpkgs_path).with_context(|| {
            format!(
                "The file ({}) is outside Nixpkgs ({})",
                self.file.display(),
                nixpkgs_path.display()
            )
        })?;
        Ok(RelativePathBuf::from_path(path).expect("relative path"))
    }
}

#[derive(Deserialize)]
pub enum AttributeVariant {
    /// The attribute is not an attribute set, we're limited in the amount of information we can get
    /// from it (though it's obviously not a derivation)
    NonAttributeSet,
    AttributeSet {
        /// Whether the attribute is a derivation (`lib.isDerivation`)
        is_derivation: bool,
        /// The type of callPackage
        definition_variant: DefinitionVariant,
    },
}

#[derive(Deserialize)]
pub enum DefinitionVariant {
    /// An automatic definition by the `pkgs/by-name` overlay
    /// Though it's detected using the internal _internalCallByNamePackageFile attribute,
    /// which can in theory also be used by other code
    AutoDefinition,
    /// A manual definition of the attribute, typically in `all-packages.nix`
    ManualDefinition {
        /// Whether the attribute is defined as `pkgs.callPackage ...` or something else.
        is_semantic_call_package: bool,
    },
}

/// Check that the Nixpkgs attribute values corresponding to the packages in pkgs/by-name are
/// of the form `callPackage <package_file> { ... }`.
/// See the `eval.nix` file for how this is achieved on the Nix side
pub fn check_values(
    nixpkgs_path: &Path,
    nix_file_store: &mut NixFileStore,
    package_names: Vec<String>,
    keep_nix_path: bool,
) -> validation::Result<ratchet::Nixpkgs> {
    // Write the list of packages we need to check into a temporary JSON file.
    // This can then get read by the Nix evaluation.
    let attrs_file = NamedTempFile::new().with_context(|| "Failed to create a temporary file")?;
    // We need to canonicalise this path because if it's a symlink (which can be the case on
    // Darwin), Nix would need to read both the symlink and the target path, therefore need 2
    // NIX_PATH entries for restrict-eval. But if we resolve the symlinks then only one predictable
    // entry is needed.
    let attrs_file_path = attrs_file.path().canonicalize()?;

    serde_json::to_writer(&attrs_file, &package_names).with_context(|| {
        format!(
            "Failed to serialise the package names to the temporary path {}",
            attrs_file_path.display()
        )
    })?;

    let expr_path = std::env::var("NIX_CHECK_BY_NAME_EXPR_PATH")
        .with_context(|| "Could not get environment variable NIX_CHECK_BY_NAME_EXPR_PATH")?;
    // With restrict-eval, only paths in NIX_PATH can be accessed, so we explicitly specify the
    // ones needed needed
    let mut command = process::Command::new("nix-instantiate");
    command
        // Inherit stderr so that error messages always get shown
        .stderr(process::Stdio::inherit())
        .args([
            "--eval",
            "--json",
            "--strict",
            "--readonly-mode",
            "--restrict-eval",
            "--show-trace",
        ])
        // Pass the path to the attrs_file as an argument and add it to the NIX_PATH so it can be
        // accessed in restrict-eval mode
        .args(["--arg", "attrsPath"])
        .arg(&attrs_file_path)
        .arg("-I")
        .arg(&attrs_file_path)
        // Same for the nixpkgs to test
        .args(["--arg", "nixpkgsPath"])
        .arg(nixpkgs_path)
        .arg("-I")
        .arg(nixpkgs_path);

    // Clear NIX_PATH to be sure it doesn't influence the result
    // But not when requested to keep it, used so that the tests can pass extra Nix files
    if !keep_nix_path {
        command.env_remove("NIX_PATH");
    }

    command.args(["-I", &expr_path]);
    command.arg(expr_path);

    let result = command
        .output()
        .with_context(|| format!("Failed to run command {command:?}"))?;

    if !result.status.success() {
        anyhow::bail!("Failed to run command {command:?}");
    }
    // Parse the resulting JSON value
    let attributes: Vec<(String, Attribute)> = serde_json::from_slice(&result.stdout)
        .with_context(|| {
            format!(
                "Failed to deserialise {}",
                String::from_utf8_lossy(&result.stdout)
            )
        })?;

    let check_result = validation::sequence(
        attributes
            .into_iter()
            .map(|(attribute_name, attribute_value)| {
                let check_result = match attribute_value {
                    Attribute::NonByName(non_by_name_attribute) => handle_non_by_name_attribute(
                        nixpkgs_path,
                        nix_file_store,
                        &attribute_name,
                        non_by_name_attribute,
                    )?,
                    Attribute::ByName(by_name_attribute) => by_name(
                        nix_file_store,
                        nixpkgs_path,
                        &attribute_name,
                        by_name_attribute,
                    )?,
                };
                Ok::<_, anyhow::Error>(check_result.map(|value| (attribute_name.clone(), value)))
            })
            .collect_vec()?,
    );

    Ok(check_result.map(|elems| ratchet::Nixpkgs {
        package_names: elems.iter().map(|(name, _)| name.to_owned()).collect(),
        package_map: elems.into_iter().collect(),
    }))
}

/// Handles the evaluation result for an attribute in `pkgs/by-name`,
/// turning it into a validation result.
fn by_name(
    nix_file_store: &mut NixFileStore,
    nixpkgs_path: &Path,
    attribute_name: &str,
    by_name_attribute: ByNameAttribute,
) -> validation::Result<ratchet::Package> {
    use ratchet::RatchetState::*;
    use ByNameAttribute::*;

    let relative_package_file = structure::relative_file_for_package(attribute_name);

    // At this point we know that `pkgs/by-name/fo/foo/package.nix` has to exists.
    // This match decides whether the attribute `foo` is defined accordingly
    // and whether a legacy manual definition could be removed
    let manual_definition_result = match by_name_attribute {
        // The attribute is missing
        Missing => {
            // This indicates a bug in the `pkgs/by-name` overlay, because it's supposed to
            // automatically defined attributes in `pkgs/by-name`
            NixpkgsProblem::UndefinedAttr {
                relative_package_file: relative_package_file.to_owned(),
                package_name: attribute_name.to_owned(),
            }
            .into()
        }
        // The attribute exists
        Existing(AttributeInfo {
            // But it's not an attribute set, which limits the amount of information we can get
            // about this attribute (see ./eval.nix)
            attribute_variant: AttributeVariant::NonAttributeSet,
            location: _location,
        }) => {
            // The only thing we know is that it's definitely not a derivation, since those are
            // always attribute sets.
            //
            // We can't know whether the attribute is automatically or manually defined for sure,
            // and while we could check the location, the error seems clear enough as is.
            NixpkgsProblem::NonDerivation {
                relative_package_file: relative_package_file.to_owned(),
                package_name: attribute_name.to_owned(),
            }
            .into()
        }
        // The attribute exists
        Existing(AttributeInfo {
            // And it's an attribute set, which allows us to get more information about it
            attribute_variant:
                AttributeVariant::AttributeSet {
                    is_derivation,
                    definition_variant,
                },
            location,
        }) => {
            // Only derivations are allowed in `pkgs/by-name`
            let is_derivation_result = if is_derivation {
                Success(())
            } else {
                NixpkgsProblem::NonDerivation {
                    relative_package_file: relative_package_file.to_owned(),
                    package_name: attribute_name.to_owned(),
                }
                .into()
            };

            // If the definition looks correct
            let variant_result = match definition_variant {
                // An automatic `callPackage` by the `pkgs/by-name` overlay.
                // Though this gets detected by checking whether the internal
                // `_internalCallByNamePackageFile` was used
                DefinitionVariant::AutoDefinition => {
                    if let Some(_location) = location {
                        // Such an automatic definition should definitely not have a location
                        // Having one indicates that somebody is using `_internalCallByNamePackageFile`,
                        NixpkgsProblem::InternalCallPackageUsed {
                            attr_name: attribute_name.to_owned(),
                        }
                        .into()
                    } else {
                        Success(Tight)
                    }
                }
                // The attribute is manually defined, e.g. in `all-packages.nix`.
                // This means we need to enforce it to look like this:
                //   callPackage ../pkgs/by-name/fo/foo/package.nix { ... }
                DefinitionVariant::ManualDefinition {
                    is_semantic_call_package,
                } => {
                    // We should expect manual definitions to have a location, otherwise we can't
                    // enforce the expected format
                    if let Some(location) = location {
                        // Parse the Nix file in the location
                        let nix_file = nix_file_store.get(&location.file)?;

                        // The relative path of the Nix file, for error messages
                        let relative_location_file = location.relative_file(nixpkgs_path).with_context(|| {
                            format!("Failed to resolve the file where attribute {attribute_name} is defined")
                        })?;

                        // Figure out whether it's an attribute definition of the form `= callPackage <arg1> <arg2>`,
                        // returning the arguments if so.
                        let (optional_syntactic_call_package, definition) = nix_file
                            .call_package_argument_info_at(location.line, location.column, nixpkgs_path)
                            .with_context(|| {
                                format!("Failed to get the definition info for attribute {attribute_name}")
                            })?;

                        by_name_override(
                            attribute_name,
                            relative_package_file,
                            is_semantic_call_package,
                            optional_syntactic_call_package,
                            definition,
                            location,
                            relative_location_file,
                        )
                    } else {
                        // If manual definitions don't have a location, it's likely `mapAttrs`'d
                        // over, e.g. if it's defined in aliases.nix.
                        // We can't verify whether its of the expected `callPackage`, so error out
                        NixpkgsProblem::CannotDetermineAttributeLocation {
                            attr_name: attribute_name.to_owned(),
                        }
                        .into()
                    }
                }
            };

            // Independently report problems about whether it's a derivation and the callPackage variant
            is_derivation_result.and(variant_result)
        }
    };
    Ok(
        // Packages being checked in this function are _always_ already defined in `pkgs/by-name`,
        // so instead of repeating ourselves all the time to define `uses_by_name`, just set it
        // once at the end with a map
        manual_definition_result.map(|manual_definition| ratchet::Package {
            manual_definition,
            uses_by_name: Tight,
        }),
    )
}

/// Handles the case for packages in `pkgs/by-name` that are manually overridden, e.g. in
/// all-packages.nix
fn by_name_override(
    attribute_name: &str,
    expected_package_file: RelativePathBuf,
    is_semantic_call_package: bool,
    optional_syntactic_call_package: Option<CallPackageArgumentInfo>,
    definition: String,
    location: Location,
    relative_location_file: RelativePathBuf,
) -> validation::Validation<ratchet::RatchetState<ratchet::ManualDefinition>> {
    // At this point, we completed two different checks for whether it's a
    // `callPackage`
    match (is_semantic_call_package, optional_syntactic_call_package) {
        // Something like `<attr> = foo`
        (_, None) => NixpkgsProblem::NonSyntacticCallPackage {
            package_name: attribute_name.to_owned(),
            file: relative_location_file,
            line: location.line,
            column: location.column,
            definition,
        }
        .into(),
        // Something like `<attr> = pythonPackages.callPackage ...`
        (false, Some(_)) => NixpkgsProblem::NonToplevelCallPackage {
            package_name: attribute_name.to_owned(),
            file: relative_location_file,
            line: location.line,
            column: location.column,
            definition,
        }
        .into(),
        // Something like `<attr> = pkgs.callPackage ...`
        (true, Some(syntactic_call_package)) => {
            if let Some(actual_package_file) = syntactic_call_package.relative_path {
                if actual_package_file != expected_package_file {
                    // Wrong path
                    NixpkgsProblem::WrongCallPackagePath {
                        package_name: attribute_name.to_owned(),
                        file: relative_location_file,
                        line: location.line,
                        actual_path: actual_package_file,
                        expected_path: expected_package_file,
                    }
                    .into()
                } else {
                    // Manual definitions with empty arguments are not allowed
                    // anymore, but existing ones should continue to be allowed
                    let manual_definition_ratchet = if syntactic_call_package.empty_arg {
                        // This is the state to migrate away from
                        Loose(NixpkgsProblem::EmptyArgument {
                            package_name: attribute_name.to_owned(),
                            file: relative_location_file,
                            line: location.line,
                            column: location.column,
                            definition,
                        })
                    } else {
                        // This is the state to migrate to
                        Tight
                    };

                    Success(manual_definition_ratchet)
                }
            } else {
                // No path
                NixpkgsProblem::NonPath {
                    package_name: attribute_name.to_owned(),
                    file: relative_location_file,
                    line: location.line,
                    column: location.column,
                    definition,
                }
                .into()
            }
        }
    }
}

/// Handles the evaluation result for an attribute _not_ in `pkgs/by-name`,
/// turning it into a validation result.
fn handle_non_by_name_attribute(
    nixpkgs_path: &Path,
    nix_file_store: &mut NixFileStore,
    attribute_name: &str,
    non_by_name_attribute: NonByNameAttribute,
) -> validation::Result<ratchet::Package> {
    use ratchet::RatchetState::*;
    use NonByNameAttribute::*;

    // The ratchet state whether this attribute uses `pkgs/by-name`.
    // This is never `Tight`, because we only either:
    // - Know that the attribute _could_ be migrated to `pkgs/by-name`, which is `Loose`
    // - Or we're unsure, in which case we use NonApplicable
    let uses_by_name =
        // This is a big ol' match on various properties of the attribute

        // First, it needs to succeed evaluation. We can't know whether an attribute could be
        // migrated to `pkgs/by-name` if it doesn't evaluate, since we need to check that it's a
        // derivation.
        //
        // This only has the minor negative effect that if a PR that breaks evaluation
        // gets merged, fixing those failures won't force anything into `pkgs/by-name`.
        //
        // For now this isn't our problem, but in the future we
        // might have another check to enforce that evaluation must not be broken.
        //
        // The alternative of assuming that failing attributes would have been fit for `pkgs/by-name`
        // has the problem that if a package evaluation gets broken temporarily,
        // fixing it requires a move to pkgs/by-name, which could happen more
        // often and isn't really justified.
        if let EvalSuccess(AttributeInfo {
            // We're only interested in attributes that are attribute sets (which includes
            // derivations). Anything else can't be in `pkgs/by-name`.
            attribute_variant: AttributeVariant::AttributeSet {
                // Indeed, we only care about derivations, non-derivation attribute sets can't be
                // in `pkgs/by-name`
                is_derivation: true,
                // Of the two definition variants, really only the manual one makes sense here.
                // Special cases are:
                // - Manual aliases to auto-called packages are not treated as manual definitions,
                //   due to limitations in the semantic callPackage detection. So those should be
                //   ignored.
                // - Manual definitions using the internal _internalCallByNamePackageFile are
                //   not treated as manual definitions, since _internalCallByNamePackageFile is
                //   used to detect automatic ones. We can't distinguish from the above case, so we
                //   just need to ignore this one too, even if that internal attribute should never
                //   be called manually.
                definition_variant: DefinitionVariant::ManualDefinition { is_semantic_call_package }
            },
            // We need the location of the manual definition, because otherwise
            // we can't figure out whether it's a syntactic callPackage
            location: Some(location),
        }) = non_by_name_attribute {

        // Parse the Nix file in the location
        let nix_file = nix_file_store.get(&location.file)?;

        // The relative path of the Nix file, for error messages
        let relative_location_file = location.relative_file(nixpkgs_path).with_context(|| {
            format!("Failed to resolve the file where attribute {attribute_name} is defined")
        })?;

        // Figure out whether it's an attribute definition of the form `= callPackage <arg1> <arg2>`,
        // returning the arguments if so.
        let (optional_syntactic_call_package, _definition) = nix_file
            .call_package_argument_info_at(
                location.line,
                location.column,
                // Passing the Nixpkgs path here both checks that the <arg1> is within Nixpkgs, and
                // strips the absolute Nixpkgs path from it, such that
                // syntactic_call_package.relative_path is relative to Nixpkgs
                nixpkgs_path
                )
            .with_context(|| {
                format!("Failed to get the definition info for attribute {attribute_name}")
            })?;

        // At this point, we completed two different checks for whether it's a
        // `callPackage`
        match (is_semantic_call_package, optional_syntactic_call_package) {
            // Something like `<attr> = { }`
            (false, None)
            // Something like `<attr> = pythonPackages.callPackage ...`
            | (false, Some(_))
            // Something like `<attr> = bar` where `bar = pkgs.callPackage ...`
            | (true, None) => {
                // In all of these cases, it's not possible to migrate the package to `pkgs/by-name`
                NonApplicable
            }
            // Something like `<attr> = pkgs.callPackage ...`
            (true, Some(syntactic_call_package)) => {
                // It's only possible to migrate such a definitions if..
                match syntactic_call_package.relative_path {
                    Some(ref rel_path) if rel_path.starts_with(utils::BASE_SUBPATH) => {
                        // ..the path is not already within `pkgs/by-name` like
                        //
                        //   foo-variant = callPackage ../by-name/fo/foo/package.nix {
                        //     someFlag = true;
                        //   }
                        //
                        // While such definitions could be moved to `pkgs/by-name` by using
                        // `.override { someFlag = true; }` instead, this changes the semantics in
                        // relation with overlays, so migration is generally not possible.
                        //
                        // See also "package variants" in RFC 140:
                        // https://github.com/NixOS/rfcs/blob/master/rfcs/0140-simple-package-paths.md#package-variants
                        NonApplicable
                    }
                    _ => {
                        // Otherwise, the path is outside `pkgs/by-name`, which means it can be
                        // migrated
                        Loose((syntactic_call_package, relative_location_file))
                    }
                }
            }
        }
    } else {
        // This catches all the cases not matched by the above `if let`, falling back to not being
        // able to migrate such attributes
        NonApplicable
    };
    Ok(Success(ratchet::Package {
        // Packages being checked in this function _always_ need a manual definition, because
        // they're not using `pkgs/by-name` which would allow avoiding it.
        // so instead of repeating ourselves all the time to define `manual_definition`,
        // just set it once at the end here
        manual_definition: Tight,
        uses_by_name,
    }))
}
