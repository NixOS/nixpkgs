mod eval;
mod nixpkgs_problem;
mod references;
mod structure;
mod utils;
mod validation;

use crate::structure::check_structure;
use crate::validation::Validation::Failure;
use crate::validation::Validation::Success;
use anyhow::Context;
use clap::{Parser, ValueEnum};
use colored::Colorize;
use std::io;
use std::path::{Path, PathBuf};
use std::process::ExitCode;

/// Program to check the validity of pkgs/by-name
#[derive(Parser, Debug)]
#[command(about)]
pub struct Args {
    /// Path to nixpkgs
    nixpkgs: PathBuf,
    /// The version of the checks
    /// Increasing this may cause failures for a Nixpkgs that succeeded before
    /// TODO: Remove default once Nixpkgs CI passes this argument
    #[arg(long, value_enum, default_value_t = Version::V0)]
    version: Version,
}

/// The version of the checks
#[derive(Debug, Clone, PartialEq, PartialOrd, ValueEnum)]
pub enum Version {
    /// Initial version
    V0,
    /// Empty argument check
    V1,
}

fn main() -> ExitCode {
    let args = Args::parse();
    match check_nixpkgs(&args.nixpkgs, args.version, vec![], &mut io::stderr()) {
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
/// - `Ok(false)` if there are problems, all of which will be written to `error_writer`.
/// - `Ok(true)` if there are no problems
pub fn check_nixpkgs<W: io::Write>(
    nixpkgs_path: &Path,
    version: Version,
    eval_accessible_paths: Vec<&Path>,
    error_writer: &mut W,
) -> anyhow::Result<bool> {
    let nixpkgs_path = nixpkgs_path.canonicalize().context(format!(
        "Nixpkgs path {} could not be resolved",
        nixpkgs_path.display()
    ))?;

    let check_result = if !nixpkgs_path.join(utils::BASE_SUBPATH).exists() {
        eprintln!(
            "Given Nixpkgs path does not contain a {} subdirectory, no check necessary.",
            utils::BASE_SUBPATH
        );
        Success(())
    } else {
        match check_structure(&nixpkgs_path)? {
            Failure(errors) => Failure(errors),
            Success(package_names) =>
            // Only if we could successfully parse the structure, we do the evaluation checks
            {
                eval::check_values(version, &nixpkgs_path, package_names, eval_accessible_paths)?
            }
        }
    };

    match check_result {
        Failure(errors) => {
            for error in errors {
                writeln!(error_writer, "{}", error.to_string().red())?
            }
            Ok(false)
        }
        Success(_) => Ok(true),
    }
}

#[cfg(test)]
mod tests {
    use crate::check_nixpkgs;
    use crate::utils;
    use crate::Version;
    use anyhow::Context;
    use std::fs;
    use std::path::Path;
    use tempfile::{tempdir_in, TempDir};

    #[test]
    fn tests_dir() -> anyhow::Result<()> {
        for entry in Path::new("tests").read_dir()? {
            let entry = entry?;
            let path = entry.path();
            let name = entry.file_name().to_string_lossy().into_owned();

            if !path.is_dir() {
                continue;
            }

            let expected_errors =
                fs::read_to_string(path.join("expected")).unwrap_or(String::new());

            test_nixpkgs(&name, &path, &expected_errors)?;
        }
        Ok(())
    }

    // tempfile::tempdir needs to be wrapped in temp_env lock
    // because it accesses TMPDIR environment variable.
    fn tempdir() -> anyhow::Result<TempDir> {
        let empty_list: [(&str, Option<&str>); 0] = [];
        Ok(temp_env::with_vars(empty_list, tempfile::tempdir)?)
    }

    // We cannot check case-conflicting files into Nixpkgs (the channel would fail to
    // build), so we generate the case-conflicting file instead.
    #[test]
    fn test_case_sensitive() -> anyhow::Result<()> {
        let temp_nixpkgs = tempdir()?;
        let path = temp_nixpkgs.path();

        if is_case_insensitive_fs(&path)? {
            eprintln!("We're on a case-insensitive filesystem, skipping case-sensitivity test");
            return Ok(());
        }

        let base = path.join(utils::BASE_SUBPATH);

        fs::create_dir_all(base.join("fo/foo"))?;
        fs::write(base.join("fo/foo/package.nix"), "{ someDrv }: someDrv")?;

        fs::create_dir_all(base.join("fo/foO"))?;
        fs::write(base.join("fo/foO/package.nix"), "{ someDrv }: someDrv")?;

        test_nixpkgs(
            "case_sensitive",
            &path,
            "pkgs/by-name/fo: Duplicate case-sensitive package directories \"foO\" and \"foo\".\n",
        )?;

        Ok(())
    }

    /// Tests symlinked temporary directories.
    /// This is needed because on darwin, `/tmp` is a symlink to `/private/tmp`, and Nix's
    /// restrict-eval doesn't also allow access to the canonical path when you allow the
    /// non-canonical one.
    ///
    /// The error if we didn't do this would look like this:
    /// error: access to canonical path '/private/var/folders/[...]/.tmpFbcNO0' is forbidden in restricted mode
    #[test]
    fn test_symlinked_tmpdir() -> anyhow::Result<()> {
        // Create a directory with two entries:
        // - actual (dir)
        // - symlinked -> actual (symlink)
        let temp_root = tempdir()?;
        fs::create_dir(temp_root.path().join("actual"))?;
        std::os::unix::fs::symlink("actual", temp_root.path().join("symlinked"))?;
        let tmpdir = temp_root.path().join("symlinked");

        temp_env::with_var("TMPDIR", Some(&tmpdir), || {
            test_nixpkgs("symlinked_tmpdir", Path::new("tests/success"), "")
        })
    }

    fn test_nixpkgs(name: &str, path: &Path, expected_errors: &str) -> anyhow::Result<()> {
        let extra_nix_path = Path::new("tests/mock-nixpkgs.nix");

        // We don't want coloring to mess up the tests
        let writer = temp_env::with_var("NO_COLOR", Some("1"), || -> anyhow::Result<_> {
            let mut writer = vec![];
            check_nixpkgs(&path, Version::V1, vec![&extra_nix_path], &mut writer)
                .context(format!("Failed test case {name}"))?;
            Ok(writer)
        })?;

        let actual_errors = String::from_utf8_lossy(&writer);

        if actual_errors != expected_errors {
            panic!(
                "Failed test case {name}, expected these errors:\n\n{}\n\nbut got these:\n\n{}",
                expected_errors, actual_errors
            );
        }
        Ok(())
    }

    /// Check whether a path is in a case-insensitive filesystem
    fn is_case_insensitive_fs(path: &Path) -> anyhow::Result<bool> {
        let dir = tempdir_in(path)?;
        let base = dir.path();
        fs::write(base.join("aaa"), "")?;
        Ok(base.join("AAA").exists())
    }
}
