mod eval;
mod references;
mod structure;
mod utils;

use anyhow::Context;
use clap::Parser;
use colored::Colorize;
use std::io;
use std::path::{Path, PathBuf};
use std::process::ExitCode;
use structure::Nixpkgs;
use utils::ErrorWriter;

/// Program to check the validity of pkgs/by-name
#[derive(Parser, Debug)]
#[command(about)]
struct Args {
    /// Path to nixpkgs
    nixpkgs: PathBuf,
}

fn main() -> ExitCode {
    let args = Args::parse();
    match check_nixpkgs(&args.nixpkgs, vec![], &mut io::stderr()) {
        Ok(true) => {
            eprintln!("{}", "Validated successfully".green());
            ExitCode::SUCCESS
        }
        Ok(false) => {
            eprintln!("{}", "Validation failed, see above errors".yellow());
            ExitCode::from(1)
        }
        Err(e) => {
            eprintln!("{} {:#}", "I/O error: ".yellow(), e);
            ExitCode::from(2)
        }
    }
}

/// Checks whether the pkgs/by-name structure in Nixpkgs is valid.
///
/// # Arguments
/// - `nixpkgs_path`: The path to the Nixpkgs to check
/// - `eval_accessible_paths`:
///   Extra paths that need to be accessible to evaluate Nixpkgs using `restrict-eval`.
///   This is used to allow the tests to access the mock-nixpkgs.nix file
/// - `error_writer`: An `io::Write` value to write validation errors to, if any.
///
/// # Return value
/// - `Err(e)` if an I/O-related error `e` occurred.
/// - `Ok(false)` if the structure is invalid, all the structural errors have been written to `error_writer`.
/// - `Ok(true)` if the structure is valid, nothing will have been written to `error_writer`.
pub fn check_nixpkgs<W: io::Write>(
    nixpkgs_path: &Path,
    eval_accessible_paths: Vec<&Path>,
    error_writer: &mut W,
) -> anyhow::Result<bool> {
    let nixpkgs_path = nixpkgs_path.canonicalize().context(format!(
        "Nixpkgs path {} could not be resolved",
        nixpkgs_path.display()
    ))?;

    // Wraps the error_writer to print everything in red, and tracks whether anything was printed
    // at all. Later used to figure out if the structure was valid or not.
    let mut error_writer = ErrorWriter::new(error_writer);

    if !nixpkgs_path.join(structure::BASE_SUBPATH).exists() {
        eprintln!(
            "Given Nixpkgs path does not contain a {} subdirectory, no check necessary.",
            structure::BASE_SUBPATH
        );
    } else {
        let nixpkgs = Nixpkgs::new(&nixpkgs_path, &mut error_writer)?;

        if error_writer.empty {
            // Only if we could successfully parse the structure, we do the semantic checks
            eval::check_values(&mut error_writer, &nixpkgs, eval_accessible_paths)?;
            references::check_references(&mut error_writer, &nixpkgs)?;
        }
    }
    Ok(error_writer.empty)
}

#[cfg(test)]
mod tests {
    use crate::check_nixpkgs;
    use anyhow::Context;
    use std::env;
    use std::fs;
    use std::path::PathBuf;

    #[test]
    fn test_cases() -> anyhow::Result<()> {
        let extra_nix_path = PathBuf::from("tests/mock-nixpkgs.nix");

        // We don't want coloring to mess up the tests
        env::set_var("NO_COLOR", "1");

        for entry in PathBuf::from("tests").read_dir()? {
            let entry = entry?;
            let path = entry.path();
            let name = entry.file_name().to_string_lossy().into_owned();

            if !entry.path().is_dir() {
                continue;
            }

            // This test explicitly makes sure we don't add files that would cause problems on
            // Darwin, so we cannot test it on Darwin itself
            #[cfg(not(target_os = "linux"))]
            if name == "case-sensitive-duplicate-package" {
                continue;
            }

            let mut writer = vec![];
            check_nixpkgs(&path, vec![&extra_nix_path], &mut writer)
                .context(format!("Failed test case {name}"))?;

            let actual_errors = String::from_utf8_lossy(&writer);
            let expected_errors =
                fs::read_to_string(path.join("expected")).unwrap_or(String::new());

            if actual_errors != expected_errors {
                panic!(
                    "Failed test case {name}, expected these errors:\n\n{}\n\nbut got these:\n\n{}",
                    expected_errors, actual_errors
                );
            }
        }
        Ok(())
    }
}
