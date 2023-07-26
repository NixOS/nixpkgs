use crate::structure;
use crate::utils::ErrorWriter;
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
    call_package_path: Option<PathBuf>,
    is_derivation: bool,
}

const EXPR: &str = include_str!("eval.nix");

/// Check that the Nixpkgs attribute values corresponding to the packages in pkgs/by-name are
/// of the form `callPackage <package_file> { ... }`.
/// See the `eval.nix` file for how this is achieved on the Nix side
pub fn check_values<W: io::Write>(
    error_writer: &mut ErrorWriter<W>,
    nixpkgs: &structure::Nixpkgs,
    eval_accessible_paths: Vec<&Path>,
) -> anyhow::Result<()> {
    // Write the list of packages we need to check into a temporary JSON file.
    // This can then get read by the Nix evaluation.
    let attrs_file = NamedTempFile::new().context("Failed to create a temporary file")?;
    serde_json::to_writer(&attrs_file, &nixpkgs.package_names).context(format!(
        "Failed to serialise the package names to the temporary path {}",
        attrs_file.path().display()
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
        .arg(attrs_file.path())
        .arg("-I")
        .arg(attrs_file.path())
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
            let is_expected_file =
                if let Some(call_package_path) = &attribute_info.call_package_path {
                    absolute_package_file == *call_package_path
                } else {
                    false
                };

            if !is_expected_file {
                error_writer.write(&format!(
                    "pkgs.{package_name}: This attribute is not defined as `pkgs.callPackage {} {{ ... }}`.",
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
