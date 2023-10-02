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
        match path.canonicalize() {
            Ok(target) => {
                // No need to handle the case of it being inside the directory, since we scan through the
                // entire directory recursively anyways
                if let Err(_prefix_error) = target.strip_prefix(context.absolute_package_dir) {
                    context.error_writer.write(&format!(
                        "{}: Path {} is a symlink pointing to a path outside the directory of that package.",
                        context.relative_package_dir.display(),
                        subpath.display(),
                    ))?;
                }
            }
            Err(e) => {
                context.error_writer.write(&format!(
                    "{}: Path {} is a symlink which cannot be resolved: {e}.",
                    context.relative_package_dir.display(),
                    subpath.display(),
                ))?;
            }
        }
    } else if path.is_dir() {
        // Recursively check each entry
        for entry in utils::read_dir_sorted(&path)? {
            let entry_subpath = subpath.join(entry.file_name());
            check_path(context, &entry_subpath)
                .context(format!("Error while recursing into {}", subpath.display()))?
        }
    } else if path.is_file() {
        // Only check Nix files
        if let Some(ext) = path.extension() {
            if ext == OsStr::new("nix") {
                check_nix_file(context, subpath).context(format!(
                    "Error while checking Nix file {}",
                    subpath.display()
                ))?
            }
        }
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
) -> anyhow::Result<()> {
    let path = context.absolute_package_dir.join(subpath);
    let parent_dir = path.parent().context(format!(
        "Could not get parent of path {}",
        subpath.display()
    ))?;

    let contents =
        read_to_string(&path).context(format!("Could not read file {}", subpath.display()))?;

    let root = Root::parse(&contents);
    if let Some(error) = root.errors().first() {
        context.error_writer.write(&format!(
            "{}: File {} could not be parsed by rnix: {}",
            context.relative_package_dir.display(),
            subpath.display(),
            error,
        ))?;
        return Ok(());
    }

    let line_index = LineIndex::new(&contents);

    for node in root.syntax().descendants() {
        // We're only interested in Path expressions
        if node.kind() != NODE_PATH {
            continue;
        }

        let text = node.text().to_string();
        let line = line_index.line(node.text_range().start().into());

        // Filters out ./foo/${bar}/baz
        // TODO: We can just check ./foo
        if node.children().count() != 0 {
            context.error_writer.write(&format!(
                "{}: File {} at line {line} contains the path expression \"{}\", which is not yet supported and may point outside the directory of that package.",
                context.relative_package_dir.display(),
                subpath.display(),
                text
            ))?;
            continue;
        }

        // Filters out search paths like <nixpkgs>
        if text.starts_with('<') {
            context.error_writer.write(&format!(
                "{}: File {} at line {line} contains the nix search path expression \"{}\" which may point outside the directory of that package.",
                context.relative_package_dir.display(),
                subpath.display(),
                text
            ))?;
            continue;
        }

        // Resolves the reference of the Nix path
        // turning `../baz` inside `/foo/bar/default.nix` to `/foo/baz`
        match parent_dir.join(Path::new(&text)).canonicalize() {
            Ok(target) => {
                // Then checking if it's still in the package directory
                // No need to handle the case of it being inside the directory, since we scan through the
                // entire directory recursively anyways
                if let Err(_prefix_error) = target.strip_prefix(context.absolute_package_dir) {
                    context.error_writer.write(&format!(
                        "{}: File {} at line {line} contains the path expression \"{}\" which may point outside the directory of that package.",
                        context.relative_package_dir.display(),
                        subpath.display(),
                        text,
                    ))?;
                }
            }
            Err(e) => {
                context.error_writer.write(&format!(
                    "{}: File {} at line {line} contains the path expression \"{}\" which cannot be resolved: {e}.",
                    context.relative_package_dir.display(),
                    subpath.display(),
                    text,
                ))?;
            }
        };
    }

    Ok(())
}
