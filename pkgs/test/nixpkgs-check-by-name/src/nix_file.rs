//! This is a utility module for interacting with the syntax of Nix files

use crate::utils::LineIndex;
use anyhow::Context;
use rnix::ast;
use rnix::ast::Expr;
use rnix::ast::HasEntry;
use rnix::SyntaxKind;
use rowan::ast::AstNode;
use rowan::TextSize;
use rowan::TokenAtOffset;
use std::collections::hash_map::Entry;
use std::collections::HashMap;
use std::fs::read_to_string;
use std::path::Path;
use std::path::PathBuf;

/// A structure to store parse results of Nix files in memory,
/// making sure that the same file never has to be parsed twice
#[derive(Default)]
pub struct NixFileStore {
    entries: HashMap<PathBuf, NixFile>,
}

impl NixFileStore {
    /// Get the store entry for a Nix file if it exists, otherwise parse the file, insert it into
    /// the store, and return the value
    ///
    /// Note that this function only gives an anyhow::Result::Err for I/O errors.
    /// A parse error is anyhow::Result::Ok(Result::Err(error))
    pub fn get(&mut self, path: &Path) -> anyhow::Result<&NixFile> {
        match self.entries.entry(path.to_owned()) {
            Entry::Occupied(entry) => Ok(entry.into_mut()),
            Entry::Vacant(entry) => Ok(entry.insert(NixFile::new(path)?)),
        }
    }
}

/// A structure for storing a successfully parsed Nix file
pub struct NixFile {
    /// The parent directory of the Nix file, for more convenient error handling
    pub parent_dir: PathBuf,
    /// The path to the file itself, for errors
    pub path: PathBuf,
    pub syntax_root: rnix::Root,
    pub line_index: LineIndex,
}

impl NixFile {
    /// Creates a new NixFile, failing for I/O or parse errors
    fn new(path: impl AsRef<Path>) -> anyhow::Result<NixFile> {
        let Some(parent_dir) = path.as_ref().parent() else {
            anyhow::bail!("Could not get parent of path {}", path.as_ref().display())
        };

        let contents = read_to_string(&path)
            .with_context(|| format!("Could not read file {}", path.as_ref().display()))?;
        let line_index = LineIndex::new(&contents);

        // NOTE: There's now another Nixpkgs CI check to make sure all changed Nix files parse
        // correctly, though that uses mainline Nix instead of rnix, so it doesn't give the same
        // errors. In the future we should unify these two checks, ideally moving the other CI
        // check into this tool as well and checking for both mainline Nix and rnix.
        rnix::Root::parse(&contents)
            // rnix's ::ok returns Result<_, _> , so no error is thrown away like it would be with
            // std::result's ::ok
            .ok()
            .map(|syntax_root| NixFile {
                parent_dir: parent_dir.to_path_buf(),
                path: path.as_ref().to_owned(),
                syntax_root,
                line_index,
            })
            .with_context(|| format!("Could not parse file {} with rnix", path.as_ref().display()))
    }
}

/// Information about callPackage arguments
#[derive(Debug, PartialEq)]
pub struct CallPackageArgumentInfo {
    /// The relative path of the first argument, or `None` if it's not a path.
    pub relative_path: Option<PathBuf>,
    /// Whether the second argument is an empty attribute set
    pub empty_arg: bool,
}

impl NixFile {
    /// Returns information about callPackage arguments for an attribute at a specific line/column
    /// index.
    /// If the location is not of the form `<attr> = callPackage <arg1> <arg2>;`, `None` is
    /// returned.
    /// This function only returns `Err` for problems that can't be caused by the Nix contents,
    /// but rather problems in this programs code itself.
    ///
    /// This is meant to be used with the location returned from `builtins.unsafeGetAttrPos`, e.g.:
    /// - Create file `default.nix` with contents
    ///   ```nix
    ///   self: {
    ///     foo = self.callPackage ./default.nix { };
    ///   }
    ///   ```
    /// - Evaluate
    ///   ```nix
    ///   builtins.unsafeGetAttrPos "foo" (import ./default.nix { })
    ///   ```
    ///   results in `{ file = ./default.nix; line = 2; column = 3; }`
    /// - Get the NixFile for `.file` from a `NixFileStore`
    /// - Call this function with `.line`, `.column` and `relative_to` as the (absolute) current directory
    ///
    /// You'll get back
    /// ```rust
    /// Some(CallPackageArgumentInfo { path = Some("default.nix"), empty_arg: true })
    /// ```
    ///
    /// Note that this also returns the same for `pythonPackages.callPackage`. It doesn't make an
    /// attempt at distinguishing this.
    pub fn call_package_argument_info_at(
        &self,
        line: usize,
        column: usize,
        relative_to: &Path,
    ) -> anyhow::Result<Option<CallPackageArgumentInfo>> {
        let Some(attrpath_value) = self.attrpath_value_at(line, column)? else {
            return Ok(None);
        };
        self.attrpath_value_call_package_argument_info(attrpath_value, relative_to)
    }

    // Internal function mainly to make it independently testable
    fn attrpath_value_at(
        &self,
        line: usize,
        column: usize,
    ) -> anyhow::Result<Option<ast::AttrpathValue>> {
        let index = self.line_index.fromlinecolumn(line, column);

        let token_at_offset = self
            .syntax_root
            .syntax()
            .token_at_offset(TextSize::from(index as u32));

        // The token_at_offset function takes indices to mean a location _between_ characters,
        // which in this case is some spacing followed by the attribute name:
        //
        //   foo = 10;
        //  /\
        //  This is the token offset, we get both the (newline + indentation) on the left side,
        //  and the attribute name on the right side.
        let TokenAtOffset::Between(_space, token) = token_at_offset else {
            anyhow::bail!("Line {line} column {column} in {} is not the start of a token, but rather {token_at_offset:?}", self.path.display())
        };

        // token looks like "foo"
        let Some(node) = token.parent() else {
            anyhow::bail!(
                "Token on line {line} column {column} in {} does not have a parent node: {token:?}",
                self.path.display()
            )
        };

        // node looks like "foo"
        let Some(attrpath_node) = node.parent() else {
            anyhow::bail!(
                "Node in {} does not have a parent node: {node:?}",
                self.path.display()
            )
        };

        if attrpath_node.kind() != SyntaxKind::NODE_ATTRPATH {
            // This can happen for e.g. `inherit foo`, so definitely not a syntactic `callPackage`
            return Ok(None);
        }
        // attrpath_node looks like "foo.bar"
        let Some(attrpath_value_node) = attrpath_node.parent() else {
            anyhow::bail!(
                "Attribute path node in {} does not have a parent node: {attrpath_node:?}",
                self.path.display()
            )
        };

        if !ast::AttrpathValue::can_cast(attrpath_value_node.kind()) {
            anyhow::bail!(
                "Node in {} is not an attribute path value node: {attrpath_value_node:?}",
                self.path.display()
            )
        }
        // attrpath_value_node looks like "foo.bar = 10;"

        // unwrap is fine because we confirmed that we can cast with the above check.
        // We could avoid this `unwrap` for a `clone`, since `cast` consumes the argument,
        // but we still need it for the error message when the cast fails.
        Ok(Some(ast::AttrpathValue::cast(attrpath_value_node).unwrap()))
    }

    // Internal function mainly to make attrpath_value_at independently testable
    fn attrpath_value_call_package_argument_info(
        &self,
        attrpath_value: ast::AttrpathValue,
        relative_to: &Path,
    ) -> anyhow::Result<Option<CallPackageArgumentInfo>> {
        let Some(attrpath) = attrpath_value.attrpath() else {
            anyhow::bail!("attrpath value node doesn't have an attrpath: {attrpath_value:?}")
        };

        // At this point we know it's something like `foo...bar = ...`

        if attrpath.attrs().count() > 1 {
            // If the attribute path has multiple entries, the left-most entry is an attribute and
            // can't be a `callPackage`.
            //
            // FIXME: `builtins.unsafeGetAttrPos` will return the same position for all attribute
            // paths and we can't really know which one it is. We could have a case like
            // `foo.bar = callPackage ... { }` and trying to determine if `bar` is a `callPackage`,
            // where this is not correct.
            // However, this case typically doesn't occur anyways,
            // because top-level packages wouldn't be nested under an attribute set.
            return Ok(None);
        }
        let Some(value) = attrpath_value.value() else {
            anyhow::bail!("attrpath value node doesn't have a value: {attrpath_value:?}")
        };

        // At this point we know it's something like `foo = ...`

        let Expr::Apply(apply1) = value else {
            // Not even a function call, instead something like `foo = null`
            return Ok(None);
        };
        let Some(function1) = apply1.lambda() else {
            anyhow::bail!("apply node doesn't have a lambda: {apply1:?}")
        };
        let Some(arg1) = apply1.argument() else {
            anyhow::bail!("apply node doesn't have an argument: {apply1:?}")
        };

        // At this point we know it's something like `foo = <fun> <arg>`.
        // For a callPackage, `<fun>` would be `callPackage ./file` and `<arg>` would be `{ }`

        let empty_arg = if let Expr::AttrSet(attrset) = arg1 {
            // We can only statically determine whether the argument is empty if it's an attribute
            // set _expression_, even though other kind of expressions could evaluate to an attribute
            // set _value_. But this is what we want anyways
            attrset.entries().next().is_none()
        } else {
            false
        };

        // Because callPackage takes two curried arguments, the first function needs to be a
        // function call itself
        let Expr::Apply(apply2) = function1 else {
            // Not a callPackage, instead something like `foo = import ./foo`
            return Ok(None);
        };
        let Some(function2) = apply2.lambda() else {
            anyhow::bail!("apply node doesn't have a lambda: {apply2:?}")
        };
        let Some(arg2) = apply2.argument() else {
            anyhow::bail!("apply node doesn't have an argument: {apply2:?}")
        };

        // At this point we know it's something like `foo = <fun2> <arg2> <arg1>`.
        // For a callPackage, `<fun2>` would be `callPackage`, `<arg2>` would be `./file`

        // Check that <arg2> is a path expression
        let path = if let Expr::Path(actual_path) = arg2 {
            // Try to statically resolve the path and turn it into a nixpkgs-relative path
            if let ResolvedPath::Within(p) = self.static_resolve_path(actual_path, relative_to) {
                Some(p)
            } else {
                // We can't statically know an existing path inside Nixpkgs used as <arg2>
                None
            }
        } else {
            // <arg2> is not a path, but rather e.g. an inline expression
            None
        };

        // Check that <fun2> is an identifier, or an attribute path with an identifier at the end
        let ident = match function2 {
            Expr::Ident(ident) => {
                // This means it's something like `foo = callPackage <arg2> <arg1>`
                ident
            }
            Expr::Select(select) => {
                // This means it's something like `foo = self.callPackage <arg2> <arg1>`.
                // We also end up here for e.g. `pythonPackages.callPackage`, but the
                // callPackage-mocking method will take care of not triggering for this case.

                if select.default_expr().is_some() {
                    // Very odd case, but this would be `foo = self.callPackage or true ./test.nix {}
                    // (yes this is valid Nix code)
                    return Ok(None);
                }
                let Some(attrpath) = select.attrpath() else {
                    anyhow::bail!("select node doesn't have an attrpath: {select:?}")
                };
                let Some(last) = attrpath.attrs().last() else {
                    // This case shouldn't be possible, it would be `foo = self. ./test.nix {}`,
                    // which shouldn't parse
                    anyhow::bail!("select node has an empty attrpath: {select:?}")
                };
                if let ast::Attr::Ident(ident) = last {
                    ident
                } else {
                    // Here it's something like `foo = self."callPackage" /test.nix {}`
                    // which we're not gonna bother with
                    return Ok(None);
                }
            }
            // Any other expression we're not gonna treat as callPackage
            _ => return Ok(None),
        };

        let Some(token) = ident.ident_token() else {
            anyhow::bail!("ident node doesn't have a token: {ident:?}")
        };

        if token.text() == "callPackage" {
            Ok(Some(CallPackageArgumentInfo {
                relative_path: path,
                empty_arg,
            }))
        } else {
            Ok(None)
        }
    }
}

/// The result of trying to statically resolve a Nix path expression
pub enum ResolvedPath {
    /// Something like `./foo/${bar}/baz`, can't be known statically
    Interpolated,
    /// Something like `<nixpkgs>`, can't be known statically
    SearchPath,
    /// Path couldn't be resolved due to an IO error,
    /// e.g. if the path doesn't exist or you don't have the right permissions
    Unresolvable(std::io::Error),
    /// The path is outside the given absolute path
    Outside,
    /// The path is within the given absolute path.
    /// The `PathBuf` is the relative path under the given absolute path.
    Within(PathBuf),
}

impl NixFile {
    /// Statically resolves a Nix path expression and checks that it's within an absolute path
    ///
    /// E.g. for the path expression `./bar.nix` in `./foo.nix` and an absolute path of the
    /// current directory, the function returns `ResolvedPath::Within(./bar.nix)`
    pub fn static_resolve_path(&self, node: ast::Path, relative_to: &Path) -> ResolvedPath {
        if node.parts().count() != 1 {
            // If there's more than 1 interpolated part, it's of the form `./foo/${bar}/baz`.
            return ResolvedPath::Interpolated;
        }

        let text = node.to_string();

        if text.starts_with('<') {
            // A search path like `<nixpkgs>`. There doesn't appear to be better way to detect
            // these in rnix
            return ResolvedPath::SearchPath;
        }

        // Join the file's parent directory and the path expression, then resolve it
        // FIXME: Expressions like `../../../../foo/bar/baz/qux` or absolute paths
        // may resolve close to the original file, but may have left the relative_to.
        // That should be checked more strictly
        match self.parent_dir.join(Path::new(&text)).canonicalize() {
            Err(resolution_error) => ResolvedPath::Unresolvable(resolution_error),
            Ok(resolved) => {
                // Check if it's within relative_to
                match resolved.strip_prefix(relative_to) {
                    Err(_prefix_error) => ResolvedPath::Outside,
                    Ok(suffix) => ResolvedPath::Within(suffix.to_path_buf()),
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::tests;
    use indoc::indoc;

    #[test]
    fn detects_attributes() -> anyhow::Result<()> {
        let temp_dir = tests::tempdir()?;
        let file = temp_dir.path().join("file.nix");
        let contents = indoc! {r#"
            toInherit: {
              foo = 1;
              "bar" = 2;
              ${"baz"} = 3;
              "${"qux"}" = 4;

              # A
              quux
              # B
              =
              # C
              5
              # D
              ;
              # E

              /**/quuux/**/=/**/5/**/;/*E*/

              inherit toInherit;
            }
        "#};

        std::fs::write(&file, contents)?;

        let nix_file = NixFile::new(&file)?;

        // These are builtins.unsafeGetAttrPos locations for the attributes
        let cases = [
            (2, 3, Some("foo = 1;")),
            (3, 3, Some(r#""bar" = 2;"#)),
            (4, 3, Some(r#"${"baz"} = 3;"#)),
            (5, 3, Some(r#""${"qux"}" = 4;"#)),
            (8, 3, Some("quux\n  # B\n  =\n  # C\n  5\n  # D\n  ;")),
            (17, 7, Some("quuux/**/=/**/5/**/;")),
            (19, 10, None),
        ];

        for (line, column, expected_result) in cases {
            let actual_result = nix_file
                .attrpath_value_at(line, column)?
                .map(|node| node.to_string());
            assert_eq!(actual_result.as_deref(), expected_result);
        }

        Ok(())
    }

    #[test]
    fn detects_call_package() -> anyhow::Result<()> {
        let temp_dir = tests::tempdir()?;
        let file = temp_dir.path().join("file.nix");
        let contents = indoc! {r#"
            self: with self; {
              a.sub = null;
              b = null;
              c = import ./file.nix;
              d = import ./file.nix { };
              e = pythonPackages.callPackage ./file.nix { };
              f = callPackage ./file.nix { };
              g = callPackage ({ }: { }) { };
              h = callPackage ./file.nix { x = 0; };
              i = callPackage ({ }: { }) (let in { });
            }
        "#};

        std::fs::write(&file, contents)?;

        let nix_file = NixFile::new(&file)?;

        let cases = [
            (2, None),
            (3, None),
            (4, None),
            (5, None),
            (
                6,
                Some(CallPackageArgumentInfo {
                    relative_path: Some(PathBuf::from("file.nix")),
                    empty_arg: true,
                }),
            ),
            (
                7,
                Some(CallPackageArgumentInfo {
                    relative_path: Some(PathBuf::from("file.nix")),
                    empty_arg: true,
                }),
            ),
            (
                8,
                Some(CallPackageArgumentInfo {
                    relative_path: None,
                    empty_arg: true,
                }),
            ),
            (
                9,
                Some(CallPackageArgumentInfo {
                    relative_path: Some(PathBuf::from("file.nix")),
                    empty_arg: false,
                }),
            ),
            (
                10,
                Some(CallPackageArgumentInfo {
                    relative_path: None,
                    empty_arg: false,
                }),
            ),
        ];

        for (line, expected_result) in cases {
            let actual_result = nix_file.call_package_argument_info_at(line, 3, temp_dir.path())?;
            assert_eq!(actual_result, expected_result);
        }

        Ok(())
    }
}
