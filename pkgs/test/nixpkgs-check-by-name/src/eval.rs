use crate::structure;
use crate::utils::ErrorWriter;
use crate::Version;
use std::path::Path;

use anyhow::Context;
use serde::Deserialize;
use std::collections::HashMap;
use std::io;
use std::path::PathBuf;
use std::process;
use tempfile::NamedTempFile;

/// Attribute set of this structure is returned by eval.nix
#[derive(Deserialize)]
struct AttributeInfo {
    variant: AttributeVariant,
    is_derivation: bool,
}

#[derive(Deserialize)]
enum AttributeVariant {
    /// The attribute is auto-called as pkgs.callPackage using pkgs/by-name,
    /// and it is not overridden by a definition in all-packages.nix
    AutoCalled,
    /// The attribute is defined as a pkgs.callPackage <path> <args>,
    /// and overridden by all-packages.nix
    CallPackage {
        /// The <path> argument or None if it's not a path
        path: Option<PathBuf>,
        /// true if <args> is { }
        empty_arg: bool,
    },
    /// The attribute is not defined as pkgs.callPackage
    Other,
}

const EXPR: &str = include_str!("eval.nix");

/// Check that the Nixpkgs attribute values corresponding to the packages in pkgs/by-name are
/// of the form `callPackage <package_file> { ... }`.
/// See the `eval.nix` file for how this is achieved on the Nix side
pub fn check_values<W: io::Write>(
    version: Version,
    error_writer: &mut ErrorWriter<W>,
    nixpkgs: &structure::Nixpkgs,
    eval_accessible_paths: Vec<&Path>,
) -> anyhow::Result<()> {
    // Write the list of packages we need to check into a temporary JSON file.
    // This can then get read by the Nix evaluation.
    let attrs_file = NamedTempFile::new().context("Failed to create a temporary file")?;
    // We need to canonicalise this path because if it's a symlink (which can be the case on
    // Darwin), Nix would need to read both the symlink and the target path, therefore need 2
    // NIX_PATH entries for restrict-eval. But if we resolve the symlinks then only one predictable
    // entry is needed.
    let attrs_file_path = attrs_file.path().canonicalize()?;

    serde_json::to_writer(&attrs_file, &nixpkgs.package_names).context(format!(
        "Failed to serialise the package names to the temporary path {}",
        attrs_file_path.display()
    ))?;

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
            "--expr",
            EXPR,
        ])
        // Pass the path to the attrs_file as an argument and add it to the NIX_PATH so it can be
        // accessed in restrict-eval mode
        .args(["--arg", "attrsPath"])
        .arg(&attrs_file_path)
        .arg("-I")
        .arg(&attrs_file_path)
        // Same for the nixpkgs to test
        .args(["--arg", "nixpkgsPath"])
        .arg(&nixpkgs.path)
        .arg("-I")
        .arg(&nixpkgs.path);

    // Also add extra paths that need to be accessible
    for path in eval_accessible_paths {
        command.arg("-I");
        command.arg(path);
    }

    let result = command
        .output()
        .context(format!("Failed to run command {command:?}"))?;

    if !result.status.success() {
        anyhow::bail!("Failed to run command {command:?}");
    }
    // Parse the resulting JSON value
    let actual_files: HashMap<String, AttributeInfo> = serde_json::from_slice(&result.stdout)
        .context(format!(
            "Failed to deserialise {}",
            String::from_utf8_lossy(&result.stdout)
        ))?;

    for package_name in &nixpkgs.package_names {
        let relative_package_file = structure::Nixpkgs::relative_file_for_package(package_name);
        let absolute_package_file = nixpkgs.path.join(&relative_package_file);

        if let Some(attribute_info) = actual_files.get(package_name) {
            let valid = match &attribute_info.variant {
                AttributeVariant::AutoCalled => true,
                AttributeVariant::CallPackage { path, empty_arg } => {
                    let correct_file = if let Some(call_package_path) = path {
                        absolute_package_file == *call_package_path
                    } else {
                        false
                    };
                    // Only check for the argument to be non-empty if the version is V1 or
                    // higher
                    let non_empty = if version >= Version::V1 {
                        !empty_arg
                    } else {
                        true
                    };
                    correct_file && non_empty
                }
                AttributeVariant::Other => false,
            };

            if !valid {
                error_writer.write(&format!(
                    "pkgs.{package_name}: This attribute is manually defined (most likely in pkgs/top-level/all-packages.nix), which is only allowed if the definition is of the form `pkgs.callPackage {} {{ ... }}` with a non-empty second argument.",
                    relative_package_file.display()
                ))?;
                continue;
            }

            if !attribute_info.is_derivation {
                error_writer.write(&format!(
                    "pkgs.{package_name}: This attribute defined by {} is not a derivation",
                    relative_package_file.display()
                ))?;
            }
        } else {
            error_writer.write(&format!(
                "pkgs.{package_name}: This attribute is not defined but it should be defined automatically as {}",
                relative_package_file.display()
            ))?;
            continue;
        }
    }
    Ok(())
}
