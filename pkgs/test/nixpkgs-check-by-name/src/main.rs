mod eval;
mod nixpkgs_problem;
mod ratchet;
mod references;
mod structure;
mod utils;
mod validation;

use crate::structure::check_structure;
use crate::validation::Validation::Failure;
use crate::validation::Validation::Success;
use anyhow::Context;
use clap::Parser;
use colored::Colorize;
use std::io;
use std::path::{Path, PathBuf};
use std::process::ExitCode;

/// Program to check the validity of pkgs/by-name
///
/// This CLI interface may be changed over time if the CI workflow making use of
/// it is adjusted to deal with the change appropriately.
///
/// Exit code:
/// - `0`: If the validation is successful
/// - `1`: If the validation is not successful
/// - `2`: If an unexpected I/O error occurs
///
/// Standard error:
/// - Informative messages
/// - Detected problems if validation is not successful
#[derive(Parser, Debug)]
#[command(about, verbatim_doc_comment)]
pub struct Args {
    /// Path to the main Nixpkgs to check.
    /// For PRs, this should be set to a checkout of the PR branch.
    nixpkgs: PathBuf,

    /// Path to the base Nixpkgs to run ratchet checks against.
    /// For PRs, this should be set to a checkout of the PRs base branch.
    /// If not specified, no ratchet checks will be performed.
    /// However, this flag will become required once CI uses it.
    #[arg(long)]
    base: Option<PathBuf>,
}

fn main() -> ExitCode {
    let args = Args::parse();
    match process(args.base.as_deref(), &args.nixpkgs, &[], &mut io::stderr()) {
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

/// Does the actual work. This is the abstraction used both by `main` and the tests.
///
/// # Arguments
/// - `base_nixpkgs`: Path to the base Nixpkgs to run ratchet checks against.
/// - `main_nixpkgs`: Path to the main Nixpkgs to check.
/// - `eval_accessible_paths`:
///   Extra paths that need to be accessible to evaluate Nixpkgs using `restrict-eval`.
///   This is used to allow the tests to access the mock-nixpkgs.nix file
/// - `error_writer`: An `io::Write` value to write validation errors to, if any.
///
/// # Return value
/// - `Err(e)` if an I/O-related error `e` occurred.
/// - `Ok(false)` if there are problems, all of which will be written to `error_writer`.
/// - `Ok(true)` if there are no problems
pub fn process<W: io::Write>(
    base_nixpkgs: Option<&Path>,
    main_nixpkgs: &Path,
    eval_accessible_paths: &[&Path],
    error_writer: &mut W,
) -> anyhow::Result<bool> {
    // Check the main Nixpkgs first
    let main_result = check_nixpkgs(main_nixpkgs, eval_accessible_paths, error_writer)?;
    let check_result = main_result.result_map(|nixpkgs_version| {
        // If the main Nixpkgs doesn't have any problems, run the ratchet checks against the base
        // Nixpkgs
        if let Some(base) = base_nixpkgs {
            check_nixpkgs(base, eval_accessible_paths, error_writer)?.result_map(
                |base_nixpkgs_version| {
                    Ok(ratchet::Nixpkgs::compare(
                        Some(base_nixpkgs_version),
                        nixpkgs_version,
                    ))
                },
            )
        } else {
            Ok(ratchet::Nixpkgs::compare(None, nixpkgs_version))
        }
    })?;

    match check_result {
        Failure(errors) => {
            for error in errors {
                writeln!(error_writer, "{}", error.to_string().red())?
            }
            Ok(false)
        }
        Success(()) => Ok(true),
    }
}

/// Checks whether the pkgs/by-name structure in Nixpkgs is valid.
///
/// This does not include ratchet checks, see ../README.md#ratchet-checks
/// Instead a `ratchet::Nixpkgs` value is returned, whose `compare` method allows performing the
/// ratchet check against another result.
pub fn check_nixpkgs<W: io::Write>(
    nixpkgs_path: &Path,
    eval_accessible_paths: &[&Path],
    error_writer: &mut W,
) -> validation::Result<ratchet::Nixpkgs> {
    Ok({
        let nixpkgs_path = nixpkgs_path.canonicalize().context(format!(
            "Nixpkgs path {} could not be resolved",
            nixpkgs_path.display()
        ))?;

        if !nixpkgs_path.join(utils::BASE_SUBPATH).exists() {
            writeln!(
                error_writer,
                "Given Nixpkgs path does not contain a {} subdirectory, no check necessary.",
                utils::BASE_SUBPATH
            )?;
            Success(ratchet::Nixpkgs::default())
        } else {
            check_structure(&nixpkgs_path)?.result_map(|package_names|
                // Only if we could successfully parse the structure, we do the evaluation checks
                eval::check_values(&nixpkgs_path, package_names, eval_accessible_paths))?
        }
    })
}

#[cfg(test)]
mod tests {
    use crate::process;
    use crate::utils;
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

        let base_path = path.join("base");
        let base_nixpkgs = if base_path.exists() {
            Some(base_path.as_path())
        } else {
            None
        };

        // We don't want coloring to mess up the tests
        let writer = temp_env::with_var("NO_COLOR", Some("1"), || -> anyhow::Result<_> {
            let mut writer = vec![];
            process(base_nixpkgs, &path, &[&extra_nix_path], &mut writer)
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
