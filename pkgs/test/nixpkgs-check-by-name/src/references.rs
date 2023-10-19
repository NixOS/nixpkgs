use crate::check_result::{
    flatten_check_results, pass, write_check_result, CheckError, CheckResult,
};
use crate::structure::Nixpkgs;
use crate::utils;
use crate::utils::{ErrorWriter, LineIndex};

use anyhow::Context;
use rnix::{Root, SyntaxKind::NODE_PATH};
use std::ffi::OsStr;
use std::fs::read_to_string;
use std::io;
use std::path::{Path, PathBuf};

/// Small helper so we don't need to pass in the same arguments to all functions
struct PackageContext<'a, W: io::Write> {
    error_writer: &'a mut ErrorWriter<W>,
    /// The package directory relative to Nixpkgs, such as `pkgs/by-name/fo/foo`
    relative_package_dir: &'a PathBuf,
    /// The absolute package directory
    absolute_package_dir: &'a PathBuf,
}

/// Check that every package directory in pkgs/by-name doesn't link to outside that directory.
/// Both symlinks and Nix path expressions are checked.
pub fn check_references<W: io::Write>(
    error_writer: &mut ErrorWriter<W>,
    nixpkgs: &Nixpkgs,
) -> anyhow::Result<()> {
    // Check the directories for each package separately
    for package_name in &nixpkgs.package_names {
        let relative_package_dir = Nixpkgs::relative_dir_for_package(package_name);
        let mut context = PackageContext {
            error_writer,
            relative_package_dir: &relative_package_dir,
            absolute_package_dir: &nixpkgs.path.join(&relative_package_dir),
        };

        // The empty argument here is the subpath under the package directory to check
        // An empty one means the package directory itself
        check_path(&mut context, Path::new("")).context(format!(
            "While checking the references in package directory {}",
            relative_package_dir.display()
        ))?;
    }
    Ok(())
}

/// Checks for a specific path to not have references outside
fn check_path<W: io::Write>(context: &mut PackageContext<W>, subpath: &Path) -> anyhow::Result<()> {
    let path = context.absolute_package_dir.join(subpath);

    if path.is_symlink() {
        // Check whether the symlink resolves to outside the package directory
        let check_result = match path.canonicalize() {
            Ok(target) => {
                // No need to handle the case of it being inside the directory, since we scan through the
                // entire directory recursively anyways
                if let Err(_prefix_error) = target.strip_prefix(context.absolute_package_dir) {
                    CheckError::OutsideSymlink {
                        relative_package_dir: context.relative_package_dir.clone(),
                        subpath: subpath.to_path_buf(),
                    }
                    .into_result()
                } else {
                    pass(())
                }
            }
            Err(io_error) => CheckError::UnresolvableSymlink {
                relative_package_dir: context.relative_package_dir.clone(),
                subpath: subpath.to_path_buf(),
                io_error,
            }
            .into_result(),
        };
        write_check_result(context.error_writer, check_result)?;
    } else if path.is_dir() {
        // Recursively check each entry
        for entry in utils::read_dir_sorted(&path)? {
            let entry_subpath = subpath.join(entry.file_name());
            check_path(context, &entry_subpath)
                .context(format!("Error while recursing into {}", subpath.display()))?
        }
    } else if path.is_file() {
        // Only check Nix files
        let check_result = if let Some(ext) = path.extension() {
            if ext == OsStr::new("nix") {
                check_nix_file(context, subpath).context(format!(
                    "Error while checking Nix file {}",
                    subpath.display()
                ))
            } else {
                pass(())
            }
        } else {
            pass(())
        };
        write_check_result(context.error_writer, check_result)?;
    } else {
        // This should never happen, git doesn't support other file types
        anyhow::bail!("Unsupported file type for path {}", subpath.display());
    }
    Ok(())
}

/// Check whether a nix file contains path expression references pointing outside the package
/// directory
fn check_nix_file<W: io::Write>(
    context: &mut PackageContext<W>,
    subpath: &Path,
) -> CheckResult<()> {
    let path = context.absolute_package_dir.join(subpath);
    let parent_dir = path.parent().context(format!(
        "Could not get parent of path {}",
        subpath.display()
    ))?;

    let contents =
        read_to_string(&path).context(format!("Could not read file {}", subpath.display()))?;

    let root = Root::parse(&contents);
    if let Some(error) = root.errors().first() {
        return CheckError::CouldNotParseNix {
            relative_package_dir: context.relative_package_dir.clone(),
            subpath: subpath.to_path_buf(),
            error: error.clone(),
        }
        .into_result();
    }

    let line_index = LineIndex::new(&contents);

    let check_results = root.syntax().descendants().map(|node| {
        let text = node.text().to_string();
        let line = line_index.line(node.text_range().start().into());

        if node.kind() != NODE_PATH {
            // We're only interested in Path expressions
            pass(())
        } else if node.children().count() != 0 {
            // Filters out ./foo/${bar}/baz
            // TODO: We can just check ./foo
            CheckError::PathInterpolation {
                relative_package_dir: context.relative_package_dir.clone(),
                subpath: subpath.to_path_buf(),
                line,
                text,
            }
            .into_result()
        } else if text.starts_with('<') {
            // Filters out search paths like <nixpkgs>
            CheckError::SearchPath {
                relative_package_dir: context.relative_package_dir.clone(),
                subpath: subpath.to_path_buf(),
                line,
                text,
            }
            .into_result()
        } else {
            // Resolves the reference of the Nix path
            // turning `../baz` inside `/foo/bar/default.nix` to `/foo/baz`
            match parent_dir.join(Path::new(&text)).canonicalize() {
                Ok(target) => {
                    // Then checking if it's still in the package directory
                    // No need to handle the case of it being inside the directory, since we scan through the
                    // entire directory recursively anyways
                    if let Err(_prefix_error) = target.strip_prefix(context.absolute_package_dir) {
                        CheckError::OutsidePathReference {
                            relative_package_dir: context.relative_package_dir.clone(),
                            subpath: subpath.to_path_buf(),
                            line,
                            text,
                        }
                        .into_result()
                    } else {
                        pass(())
                    }
                }
                Err(e) => CheckError::UnresolvablePathReference {
                    relative_package_dir: context.relative_package_dir.clone(),
                    subpath: subpath.to_path_buf(),
                    line,
                    text,
                    io_error: e,
                }
                .into_result(),
            }
        }
    });
    flatten_check_results(check_results, |_| ())
}
