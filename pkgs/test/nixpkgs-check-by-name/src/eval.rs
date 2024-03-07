use crate::nixpkgs_problem::NixpkgsProblem;
use crate::ratchet;
use crate::structure;
use crate::validation::{self, Validation::Success};
use std::path::Path;

use anyhow::Context;
use serde::Deserialize;
use std::path::PathBuf;
use std::process;
use tempfile::NamedTempFile;

/// Attribute set of this structure is returned by eval.nix
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
    package_names: Vec<String>,
    eval_accessible_paths: &[&Path],
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
        // Clear NIX_PATH to be sure it doesn't influence the result
        .env_remove("NIX_PATH")
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

    // Also add extra paths that need to be accessible
    for path in eval_accessible_paths {
        command.arg("-I");
        command.arg(path);
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
    let attributes: Vec<(String, ByNameAttribute)> = serde_json::from_slice(&result.stdout)
        .with_context(|| {
            format!(
                "Failed to deserialise {}",
                String::from_utf8_lossy(&result.stdout)
            )
        })?;

    let check_result = validation::sequence(attributes.into_iter().map(
        |(attribute_name, attribute_value)| {
            let relative_package_file = structure::relative_file_for_package(&attribute_name);

            use ratchet::RatchetState::*;
            use AttributeInfo::*;
            use ByNameAttribute::*;
            use CallPackageVariant::*;

            let check_result = match attribute_value {
                Missing => NixpkgsProblem::UndefinedAttr {
                    relative_package_file: relative_package_file.clone(),
                    package_name: attribute_name.clone(),
                }
                .into(),
                Existing(NonAttributeSet) => NixpkgsProblem::NonDerivation {
                    relative_package_file: relative_package_file.clone(),
                    package_name: attribute_name.clone(),
                }
                .into(),
                Existing(NonCallPackage) => NixpkgsProblem::WrongCallPackage {
                    relative_package_file: relative_package_file.clone(),
                    package_name: attribute_name.clone(),
                }
                .into(),
                Existing(CallPackage(CallPackageInfo {
                    is_derivation,
                    call_package_variant,
                })) => {
                    let check_result = if !is_derivation {
                        NixpkgsProblem::NonDerivation {
                            relative_package_file: relative_package_file.clone(),
                            package_name: attribute_name.clone(),
                        }
                        .into()
                    } else {
                        Success(())
                    };

                    check_result.and(match &call_package_variant {
                        Auto => Success(ratchet::Package {
                            empty_non_auto_called: Tight,
                        }),
                        Manual { path, empty_arg } => {
                            let correct_file = if let Some(call_package_path) = path {
                                relative_package_file == *call_package_path
                            } else {
                                false
                            };

                            if correct_file {
                                Success(ratchet::Package {
                                    // Empty arguments for non-auto-called packages are not allowed anymore.
                                    empty_non_auto_called: if *empty_arg {
                                        Loose(ratchet::EmptyNonAutoCalled)
                                    } else {
                                        Tight
                                    },
                                })
                            } else {
                                NixpkgsProblem::WrongCallPackage {
                                    relative_package_file: relative_package_file.clone(),
                                    package_name: attribute_name.clone(),
                                }
                                .into()
                            }
                        }
                    })
                }
            };
            check_result.map(|value| (attribute_name.clone(), value))
        },
    ));

    Ok(check_result.map(|elems| ratchet::Nixpkgs {
        package_names,
        package_map: elems.into_iter().collect(),
    }))
}
