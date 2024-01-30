use crate::nixpkgs_problem::NixpkgsProblem;
use crate::utils;
use crate::validation::{self, ResultIteratorExt, Validation::Success};
use crate::NixFileCache;

use rowan::ast::AstNode;
use anyhow::Context;
use std::ffi::OsStr;
use std::path::Path;

/// Check that every package directory in pkgs/by-name doesn't link to outside that directory.
/// Both symlinks and Nix path expressions are checked.
pub fn check_references(
    nix_file_cache: &mut NixFileCache,
    relative_package_dir: &Path,
    absolute_package_dir: &Path,
) -> validation::Result<()> {
    // The empty argument here is the subpath under the package directory to check
    // An empty one means the package directory itself
    check_path(nix_file_cache, relative_package_dir, absolute_package_dir, Path::new("")).with_context(|| {
        format!(
            "While checking the references in package directory {}",
            relative_package_dir.display()
        )
    })
}

/// Checks for a specific path to not have references outside
fn check_path(
    nix_file_cache: &mut NixFileCache,
    relative_package_dir: &Path,
    absolute_package_dir: &Path,
    subpath: &Path,
) -> validation::Result<()> {
    let path = absolute_package_dir.join(subpath);

    Ok(if path.is_symlink() {
        // Check whether the symlink resolves to outside the package directory
        match path.canonicalize() {
            Ok(target) => {
                // No need to handle the case of it being inside the directory, since we scan through the
                // entire directory recursively anyways
                if let Err(_prefix_error) = target.strip_prefix(absolute_package_dir) {
                    NixpkgsProblem::OutsideSymlink {
                        relative_package_dir: relative_package_dir.to_path_buf(),
                        subpath: subpath.to_path_buf(),
                    }
                    .into()
                } else {
                    Success(())
                }
            }
            Err(io_error) => NixpkgsProblem::UnresolvableSymlink {
                relative_package_dir: relative_package_dir.to_path_buf(),
                subpath: subpath.to_path_buf(),
                io_error,
            }
            .into(),
        }
    } else if path.is_dir() {
        // Recursively check each entry
        validation::sequence_(
            utils::read_dir_sorted(&path)?
                .into_iter()
                .map(|entry| {
                    let entry_subpath = subpath.join(entry.file_name());
                    check_path(nix_file_cache, relative_package_dir, absolute_package_dir, &entry_subpath)
                        .with_context(|| {
                            format!("Error while recursing into {}", subpath.display())
                        })
                })
                .collect_vec()?,
        )
    } else if path.is_file() {
        // Only check Nix files
        if let Some(ext) = path.extension() {
            if ext == OsStr::new("nix") {
                check_nix_file(nix_file_cache, relative_package_dir, absolute_package_dir, subpath).with_context(
                    || format!("Error while checking Nix file {}", subpath.display()),
                )?
            } else {
                Success(())
            }
        } else {
            Success(())
        }
    } else {
        // This should never happen, git doesn't support other file types
        anyhow::bail!("Unsupported file type for path {}", subpath.display());
    })
}

/// Check whether a nix file contains path expression references pointing outside the package
/// directory
fn check_nix_file(
    nix_file_cache: &mut NixFileCache,
    relative_package_dir: &Path,
    absolute_package_dir: &Path,
    subpath: &Path,
) -> validation::Result<()> {
    let path = absolute_package_dir.join(subpath);

    let nix_file = match nix_file_cache.get(&path)? {
        Ok(nix_file) => nix_file,
        Err(error) =>
        // NOTE: There's now another Nixpkgs CI check to make sure all changed Nix files parse
        // correctly, though that uses mainline Nix instead of rnix, so it doesn't give the same
        // errors. In the future we should unify these two checks, ideally moving the other CI
        // check into this tool as well and checking for both mainline Nix and rnix.
        return Ok(NixpkgsProblem::CouldNotParseNix {
            relative_package_dir: relative_package_dir.to_path_buf(),
            subpath: subpath.to_path_buf(),
            error: error.clone(),
        }
        .into())
    };

    Ok(validation::sequence_(nix_file.syntax_root.syntax().descendants().map(
        |node| {
            let text = node.text().to_string();
            let line = nix_file.line_index.line(node.text_range().start().into());

                // We're only interested in Path expressions
                let Some(path) = rnix::ast::Path::cast(node) else {
                    return Success(())
                };

                use crate::nix_file::ResolvedPath::*;

                match nix_file.static_resolve_path(path, absolute_package_dir) {
                Interpolated =>
                // Filters out ./foo/${bar}/baz
                // TODO: We can just check ./foo
                NixpkgsProblem::PathInterpolation {
                    relative_package_dir: relative_package_dir.to_path_buf(),
                    subpath: subpath.to_path_buf(),
                    line,
                    text,
                }
                .into(),
                SearchPath =>
                // Filters out search paths like <nixpkgs>
                NixpkgsProblem::SearchPath {
                    relative_package_dir: relative_package_dir.to_path_buf(),
                    subpath: subpath.to_path_buf(),
                    line,
                    text,
                }
                .into(),
                            Outside => NixpkgsProblem::OutsidePathReference {
                                relative_package_dir: relative_package_dir.to_path_buf(),
                                subpath: subpath.to_path_buf(),
                                line,
                                text,
                            }
                            .into(),
                    Unresolvable(e) => NixpkgsProblem::UnresolvablePathReference {
                        relative_package_dir: relative_package_dir.to_path_buf(),
                        subpath: subpath.to_path_buf(),
                        line,
                        text,
                        io_error: e,
                    }
                    .into(),
                    Within(_p) =>
                    // No need to handle the case of it being inside the directory, since we scan through the
                    // entire directory recursively anyways
                    Success(())
                }
        }),
    ))
}
