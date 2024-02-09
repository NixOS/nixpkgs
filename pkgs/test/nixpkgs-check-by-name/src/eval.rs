use crate::nixpkgs_problem::NixpkgsProblem;
use crate::ratchet;
use crate::structure;
use crate::utils;
use crate::validation::ResultIteratorExt as _;
use crate::validation::{self, Validation::Success};
use crate::NixFileStore;
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
enum AttributeInfo {
    /// The attribute exists, but its value isn't an attribute set
    NonAttributeSet,
    /// The attribute exists, but its value isn't defined using callPackage
    NonCallPackage,
    /// The attribute exists and its value is an attribute set
    CallPackage(CallPackageInfo),
}

#[derive(Deserialize)]
struct CallPackageInfo {
    call_package_variant: CallPackageVariant,
    /// Whether the attribute is a derivation (`lib.isDerivation`)
    is_derivation: bool,
    location: Option<Location>,
}

/// The structure returned by `builtins.unsafeGetAttrPos`
#[derive(Deserialize, Clone, Debug)]
struct Location {
    pub file: PathBuf,
    pub line: usize,
    pub column: usize,
}

#[derive(Deserialize)]
enum CallPackageVariant {
    /// The attribute is auto-called as pkgs.callPackage using pkgs/by-name,
    /// and it is not overridden by a definition in all-packages.nix
    Auto,
    /// The attribute is defined as a pkgs.callPackage <path> <args>,
    /// and overridden by all-packages.nix
    Manual {
        /// The <path> argument or None if it's not a path
        path: Option<PathBuf>,
        /// true if <args> is { }
        empty_arg: bool,
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
                        non_by_name_attribute,
                    )?,
                    Attribute::ByName(by_name_attribute) => {
                        by_name(&attribute_name, by_name_attribute)
                    }
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
    attribute_name: &str,
    by_name_attribute: ByNameAttribute,
) -> validation::Validation<ratchet::Package> {
    use ratchet::RatchetState::*;
    use AttributeInfo::*;
    use ByNameAttribute::*;
    use CallPackageVariant::*;

    let relative_package_file = structure::relative_file_for_package(attribute_name);

    match by_name_attribute {
        Missing => NixpkgsProblem::UndefinedAttr {
            relative_package_file: relative_package_file.to_owned(),
            package_name: attribute_name.to_owned(),
        }
        .into(),
        Existing(NonAttributeSet) => NixpkgsProblem::NonDerivation {
            relative_package_file: relative_package_file.to_owned(),
            package_name: attribute_name.to_owned(),
        }
        .into(),
        Existing(NonCallPackage) => NixpkgsProblem::WrongCallPackage {
            relative_package_file: relative_package_file.to_owned(),
            package_name: attribute_name.to_owned(),
        }
        .into(),
        Existing(CallPackage(CallPackageInfo {
            is_derivation,
            call_package_variant,
            ..
        })) => {
            let check_result = if !is_derivation {
                NixpkgsProblem::NonDerivation {
                    relative_package_file: relative_package_file.to_owned(),
                    package_name: attribute_name.to_owned(),
                }
                .into()
            } else {
                Success(())
            };

            check_result.and(match &call_package_variant {
                Auto => Success(ratchet::Package {
                    manual_definition: Tight,
                    uses_by_name: Tight,
                }),
                // TODO: Use the call_package_argument_info_at instead/additionally and
                // simplify the eval.nix code
                Manual { path, empty_arg } => {
                    let correct_file = if let Some(call_package_path) = path {
                        relative_package_file == *call_package_path
                    } else {
                        false
                    };

                    if correct_file {
                        Success(ratchet::Package {
                            // Empty arguments for non-auto-called packages are not allowed anymore.
                            manual_definition: if *empty_arg { Loose(()) } else { Tight },
                            uses_by_name: Tight,
                        })
                    } else {
                        NixpkgsProblem::WrongCallPackage {
                            relative_package_file: relative_package_file.to_owned(),
                            package_name: attribute_name.to_owned(),
                        }
                        .into()
                    }
                }
            })
        }
    }
}

/// Handles the evaluation result for an attribute _not_ in `pkgs/by-name`,
/// turning it into a validation result.
fn handle_non_by_name_attribute(
    nixpkgs_path: &Path,
    nix_file_store: &mut NixFileStore,
    non_by_name_attribute: NonByNameAttribute,
) -> validation::Result<ratchet::Package> {
    use ratchet::RatchetState::*;
    use AttributeInfo::*;
    use CallPackageVariant::*;
    use NonByNameAttribute::*;

    Ok(match non_by_name_attribute {
        // The attribute succeeds evaluation and is NOT defined in pkgs/by-name
        EvalSuccess(attribute_info) => {
            let uses_by_name = match attribute_info {
                // In these cases the package doesn't qualify for being in pkgs/by-name,
                // so the UsesByName ratchet is already as tight as it can be
                NonAttributeSet => Success(NonApplicable),
                NonCallPackage => Success(NonApplicable),
                // This is the case when the `pkgs/by-name`-internal _internalCallByNamePackageFile
                // is used for a package outside `pkgs/by-name`
                CallPackage(CallPackageInfo {
                    call_package_variant: Auto,
                    ..
                }) => {
                    // With the current detection mechanism, this also triggers for aliases
                    // to pkgs/by-name packages, and there's no good method of
                    // distinguishing alias vs non-alias.
                    // Using `config.allowAliases = false` at least currently doesn't work
                    // because there's nothing preventing people from defining aliases that
                    // are present even with that disabled.
                    // In the future we could kind of abuse this behavior to have better
                    // enforcement of conditional aliases, but for now we just need to not
                    // give an error.
                    Success(NonApplicable)
                }
                // Only derivations can be in pkgs/by-name,
                // so this attribute doesn't qualify
                CallPackage(CallPackageInfo {
                    is_derivation: false,
                    ..
                }) => Success(NonApplicable),
                // A location of None indicates something weird, we can't really know where
                // this attribute is defined, probably an alias
                CallPackage(CallPackageInfo { location: None, .. }) => Success(Tight),
                // The case of an attribute that qualifies:
                // - Uses callPackage
                // - Is a derivation
                CallPackage(CallPackageInfo {
                    is_derivation: true,
                    call_package_variant: Manual { .. },
                    location: Some(location),
                }) =>
                // We'll use the attribute's location to parse the file that defines it
                {
                    match nix_file_store
                        .get(&location.file)?
                        .call_package_argument_info_at(
                            location.line,
                            location.column,
                            nixpkgs_path,
                        )? {
                        // If the definition is not of the form `<attr> = callPackage <arg1> <arg2>;`,
                        // it's generally not possible to migrate to `pkgs/by-name`
                        None => Success(NonApplicable),
                        Some(call_package_argument_info) => {
                            if let Some(ref rel_path) = call_package_argument_info.relative_path {
                                if rel_path.starts_with(utils::BASE_SUBPATH) {
                                    // Package variants of by-name packages are explicitly allowed according to RFC 140
                                    // https://github.com/NixOS/rfcs/blob/master/rfcs/0140-simple-package-paths.md#package-variants:
                                    //
                                    // foo-variant = callPackage ../by-name/fo/foo/package.nix {
                                    //   someFlag = true;
                                    // }
                                    //
                                    // While such definitions could be moved to `pkgs/by-name` by using
                                    // `.override { someFlag = true; }` instead, this changes the semantics in
                                    // relation with overlays.
                                    Success(NonApplicable)
                                } else {
                                    Success(Loose(call_package_argument_info))
                                }
                            } else {
                                Success(Loose(call_package_argument_info))
                            }
                        }
                    }
                }
            };
            uses_by_name.map(|x| ratchet::Package {
                manual_definition: Tight,
                uses_by_name: x,
            })
        }
        EvalFailure => {
            // We don't know anything about this attribute really
            Success(ratchet::Package {
                // We'll assume that we can't remove any manual definitions, which has the
                // minimal drawback that if there was a manual definition that could've
                // been removed, fixing the package requires removing the definition, no
                // big deal, that's a minor edit.
                manual_definition: Tight,

                // Regarding whether this attribute could `pkgs/by-name`, we don't really
                // know, so return NonApplicable, which has the effect that if a
                // package evaluation gets broken temporarily, the fix can remove it from
                // pkgs/by-name again. For now this isn't our problem, but in the future we
                // might have another check to enforce that evaluation must not be broken.
                // The alternative of assuming that it's using `pkgs/by-name` already
                // has the problem that if a package evaluation gets broken temporarily,
                // fixing it requires a move to pkgs/by-name, which could happen more
                // often and isn't really justified.
                uses_by_name: NonApplicable,
            })
        }
    })
}
