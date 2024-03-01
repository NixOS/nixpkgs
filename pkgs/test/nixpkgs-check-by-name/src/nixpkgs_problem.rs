use crate::structure;
use crate::utils::PACKAGE_NIX_FILENAME;
use indoc::writedoc;
use relative_path::RelativePath;
use relative_path::RelativePathBuf;
use std::ffi::OsString;
use std::fmt;

/// Any problem that can occur when checking Nixpkgs
/// All paths are relative to Nixpkgs such that the error messages can't be influenced by Nixpkgs absolute
/// location
#[derive(Clone)]
pub enum NixpkgsProblem {
    ShardNonDir {
        relative_shard_path: RelativePathBuf,
    },
    InvalidShardName {
        relative_shard_path: RelativePathBuf,
        shard_name: String,
    },
    PackageNonDir {
        relative_package_dir: RelativePathBuf,
    },
    CaseSensitiveDuplicate {
        relative_shard_path: RelativePathBuf,
        first: OsString,
        second: OsString,
    },
    InvalidPackageName {
        relative_package_dir: RelativePathBuf,
        package_name: String,
    },
    IncorrectShard {
        relative_package_dir: RelativePathBuf,
        correct_relative_package_dir: RelativePathBuf,
    },
    PackageNixNonExistent {
        relative_package_dir: RelativePathBuf,
    },
    PackageNixDir {
        relative_package_dir: RelativePathBuf,
    },
    UndefinedAttr {
        relative_package_file: RelativePathBuf,
        package_name: String,
    },
    EmptyArgument {
        package_name: String,
        file: RelativePathBuf,
        line: usize,
        column: usize,
        definition: String,
    },
    NonToplevelCallPackage {
        package_name: String,
        file: RelativePathBuf,
        line: usize,
        column: usize,
        definition: String,
    },
    NonPath {
        package_name: String,
        file: RelativePathBuf,
        line: usize,
        column: usize,
        definition: String,
    },
    WrongCallPackagePath {
        package_name: String,
        file: RelativePathBuf,
        line: usize,
        actual_path: RelativePathBuf,
        expected_path: RelativePathBuf,
    },
    NonSyntacticCallPackage {
        package_name: String,
        file: RelativePathBuf,
        line: usize,
        column: usize,
        definition: String,
    },
    NonDerivation {
        relative_package_file: RelativePathBuf,
        package_name: String,
    },
    OutsideSymlink {
        relative_package_dir: RelativePathBuf,
        subpath: RelativePathBuf,
    },
    UnresolvableSymlink {
        relative_package_dir: RelativePathBuf,
        subpath: RelativePathBuf,
        io_error: String,
    },
    PathInterpolation {
        relative_package_dir: RelativePathBuf,
        subpath: RelativePathBuf,
        line: usize,
        text: String,
    },
    SearchPath {
        relative_package_dir: RelativePathBuf,
        subpath: RelativePathBuf,
        line: usize,
        text: String,
    },
    OutsidePathReference {
        relative_package_dir: RelativePathBuf,
        subpath: RelativePathBuf,
        line: usize,
        text: String,
    },
    UnresolvablePathReference {
        relative_package_dir: RelativePathBuf,
        subpath: RelativePathBuf,
        line: usize,
        text: String,
        io_error: String,
    },
    MovedOutOfByNameEmptyArg {
        package_name: String,
        call_package_path: Option<RelativePathBuf>,
        file: RelativePathBuf,
    },
    MovedOutOfByNameNonEmptyArg {
        package_name: String,
        call_package_path: Option<RelativePathBuf>,
        file: RelativePathBuf,
    },
    NewPackageNotUsingByNameEmptyArg {
        package_name: String,
        call_package_path: Option<RelativePathBuf>,
        file: RelativePathBuf,
    },
    NewPackageNotUsingByNameNonEmptyArg {
        package_name: String,
        call_package_path: Option<RelativePathBuf>,
        file: RelativePathBuf,
    },
    InternalCallPackageUsed {
        attr_name: String,
    },
    CannotDetermineAttributeLocation {
        attr_name: String,
    },
}

impl fmt::Display for NixpkgsProblem {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            NixpkgsProblem::ShardNonDir { relative_shard_path } =>
                write!(
                    f,
                    "{}: This is a file, but it should be a directory.",
                    relative_shard_path,
                ),
            NixpkgsProblem::InvalidShardName { relative_shard_path, shard_name } =>
                write!(
                    f,
                    "{}: Invalid directory name \"{shard_name}\", must be at most 2 ASCII characters consisting of a-z, 0-9, \"-\" or \"_\".",
                    relative_shard_path,
                ),
            NixpkgsProblem::PackageNonDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: This path is a file, but it should be a directory.",
                    relative_package_dir,
                ),
            NixpkgsProblem::CaseSensitiveDuplicate { relative_shard_path, first, second } =>
                write!(
                    f,
                    "{}: Duplicate case-sensitive package directories {first:?} and {second:?}.",
                    relative_shard_path,
                ),
            NixpkgsProblem::InvalidPackageName { relative_package_dir, package_name } =>
                write!(
                    f,
                    "{}: Invalid package directory name \"{package_name}\", must be ASCII characters consisting of a-z, A-Z, 0-9, \"-\" or \"_\".",
                    relative_package_dir,
                ),
            NixpkgsProblem::IncorrectShard { relative_package_dir, correct_relative_package_dir } =>
                write!(
                    f,
                    "{}: Incorrect directory location, should be {} instead.",
                    relative_package_dir,
                    correct_relative_package_dir,
                ),
            NixpkgsProblem::PackageNixNonExistent { relative_package_dir } =>
                write!(
                    f,
                    "{}: Missing required \"{PACKAGE_NIX_FILENAME}\" file.",
                    relative_package_dir,
                ),
            NixpkgsProblem::PackageNixDir { relative_package_dir } =>
                write!(
                    f,
                    "{}: \"{PACKAGE_NIX_FILENAME}\" must be a file.",
                    relative_package_dir,
                ),
            NixpkgsProblem::UndefinedAttr { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute is not defined but it should be defined automatically as {}",
                    relative_package_file,
                ),
            NixpkgsProblem::EmptyArgument { package_name, file, line, column, definition } =>
                writedoc!(
                    f,
                    "
                    - Because {} exists, the attribute `pkgs.{package_name}` must be defined like

                        {package_name} = callPackage ./{} {{ /* ... */ }};

                      However, in this PR, the second argument is empty. See the definition in {}:{}:

                    {}

                      Such a definition is provided automatically and therefore not necessary. Please remove it.
                    ",
                    structure::relative_dir_for_package(package_name),
                    structure::relative_file_for_package(package_name),
                    file,
                    line,
                    indent_definition(*column, definition.clone()),
                ),
            NixpkgsProblem::NonToplevelCallPackage { package_name, file, line, column, definition } =>
                writedoc!(
                    f,
                    "
                    - Because {} exists, the attribute `pkgs.{package_name}` must be defined like

                        {package_name} = callPackage ./{} {{ /* ... */ }};

                      However, in this PR, a different `callPackage` is used. See the definition in {}:{}:

                    {}
                    ",
                    structure::relative_dir_for_package(package_name),
                    structure::relative_file_for_package(package_name),
                    file,
                    line,
                    indent_definition(*column, definition.clone()),
                ),
            NixpkgsProblem::NonPath { package_name, file, line, column, definition } =>
                writedoc!(
                    f,
                    "
                    - Because {} exists, the attribute `pkgs.{package_name}` must be defined like

                        {package_name} = callPackage ./{} {{ /* ... */ }};

                      However, in this PR, the first `callPackage` argument is not a path. See the definition in {}:{}:

                    {}
                    ",
                    structure::relative_dir_for_package(package_name),
                    structure::relative_file_for_package(package_name),
                    file,
                    line,
                    indent_definition(*column, definition.clone()),
                ),
            NixpkgsProblem::WrongCallPackagePath { package_name, file, line, actual_path, expected_path } =>
                writedoc! {
                    f,
                    "
                    - Because {} exists, the attribute `pkgs.{package_name}` must be defined like

                        {package_name} = callPackage {} {{ /* ... */ }};

                      However, in this PR, the first `callPackage` argument is the wrong path. See the definition in {}:{}:

                        {package_name} = callPackage {} {{ /* ... */ }};
                    ",
                    structure::relative_dir_for_package(package_name),
                    create_path_expr(file, expected_path),
                    file, line,
                    create_path_expr(file, actual_path),
                },
            NixpkgsProblem::NonSyntacticCallPackage { package_name, file, line, column, definition } => {
                writedoc!(
                    f,
                    "
                    - Because {} exists, the attribute `pkgs.{package_name}` must be defined like

                        {package_name} = callPackage ./{} {{ /* ... */ }};

                      However, in this PR, it isn't defined that way. See the definition in {}:{}

                    {}
                    ",
                    structure::relative_dir_for_package(package_name),
                    structure::relative_file_for_package(package_name),
                    file,
                    line,
                    indent_definition(*column, definition.clone()),
                )
            }
            NixpkgsProblem::NonDerivation { relative_package_file, package_name } =>
                write!(
                    f,
                    "pkgs.{package_name}: This attribute defined by {} is not a derivation",
                    relative_package_file,
                ),
            NixpkgsProblem::OutsideSymlink { relative_package_dir, subpath } =>
                write!(
                    f,
                    "{}: Path {} is a symlink pointing to a path outside the directory of that package.",
                    relative_package_dir,
                    subpath,
                ),
            NixpkgsProblem::UnresolvableSymlink { relative_package_dir, subpath, io_error } =>
                write!(
                    f,
                    "{}: Path {} is a symlink which cannot be resolved: {io_error}.",
                    relative_package_dir,
                    subpath,
                ),
            NixpkgsProblem::PathInterpolation { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\", which is not yet supported and may point outside the directory of that package.",
                    relative_package_dir,
                    subpath,
                    text
                ),
            NixpkgsProblem::SearchPath { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the nix search path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir,
                    subpath,
                    text
                ),
            NixpkgsProblem::OutsidePathReference { relative_package_dir, subpath, line, text } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\" which may point outside the directory of that package.",
                    relative_package_dir,
                    subpath,
                    text,
                ),
            NixpkgsProblem::UnresolvablePathReference { relative_package_dir, subpath, line, text, io_error } =>
                write!(
                    f,
                    "{}: File {} at line {line} contains the path expression \"{}\" which cannot be resolved: {io_error}.",
                    relative_package_dir,
                    subpath,
                    text,
                ),
            NixpkgsProblem::MovedOutOfByNameEmptyArg { package_name, call_package_path, file } => {
                let call_package_arg =
                    if let Some(path) = &call_package_path {
                        format!("./{}", path)
                    } else {
                        "...".into()
                    };
                writedoc!(
                    f,
                    "
                    - Attribute `pkgs.{package_name}` was previously defined in {}, but is now manually defined as `callPackage {call_package_arg} {{ /* ... */ }}` in {}.
                      Please move the package back and remove the manual `callPackage`.
                    ",
                    structure::relative_file_for_package(package_name),
                    file,
                    )
            },
            NixpkgsProblem::MovedOutOfByNameNonEmptyArg { package_name, call_package_path, file } => {
                let call_package_arg =
                    if let Some(path) = &call_package_path {
                        format!("./{}", path)
                    } else {
                        "...".into()
                    };
                // This can happen if users mistakenly assume that for custom arguments,
                // pkgs/by-name can't be used.
                writedoc!(
                    f,
                    "
                    - Attribute `pkgs.{package_name}` was previously defined in {}, but is now manually defined as `callPackage {call_package_arg} {{ ... }}` in {}.
                      While the manual `callPackage` is still needed, it's not necessary to move the package files.
                    ",
                    structure::relative_file_for_package(package_name),
                    file,
                    )
            },
            NixpkgsProblem::NewPackageNotUsingByNameEmptyArg { package_name, call_package_path, file } => {
                let call_package_arg =
                    if let Some(path) = &call_package_path {
                        format!("./{}", path)
                    } else {
                        "...".into()
                    };
                writedoc!(
                    f,
                    "
                    - Attribute `pkgs.{package_name}` is a new top-level package using `pkgs.callPackage {call_package_arg} {{ /* ... */ }}`.
                      Please define it in {} instead.
                      See `pkgs/by-name/README.md` for more details.
                      Since the second `callPackage` argument is `{{ }}`, no manual `callPackage` in {} is needed anymore.
                    ",
                    structure::relative_file_for_package(package_name),
                    file,
                )
            },
            NixpkgsProblem::NewPackageNotUsingByNameNonEmptyArg { package_name, call_package_path, file } => {
                let call_package_arg =
                    if let Some(path) = &call_package_path {
                        format!("./{}", path)
                    } else {
                        "...".into()
                    };
                writedoc!(
                    f,
                    "
                    - Attribute `pkgs.{package_name}` is a new top-level package using `pkgs.callPackage {call_package_arg} {{ /* ... */ }}`.
                      Please define it in {} instead.
                      See `pkgs/by-name/README.md` for more details.
                      Since the second `callPackage` argument is not `{{ }}`, the manual `callPackage` in {} is still needed.
                    ",
                    structure::relative_file_for_package(package_name),
                    file,
                )
            },
            NixpkgsProblem::InternalCallPackageUsed { attr_name } =>
                write!(
                    f,
                    "pkgs.{attr_name}: This attribute is defined using `_internalCallByNamePackageFile`, which is an internal function not intended for manual use.",
                ),
            NixpkgsProblem::CannotDetermineAttributeLocation { attr_name } =>
                write!(
                    f,
                    "pkgs.{attr_name}: Cannot determine the location of this attribute using `builtins.unsafeGetAttrPos`.",
                ),
       }
    }
}

fn indent_definition(column: usize, definition: String) -> String {
    // The entire code should be indented 4 spaces
    textwrap::indent(
        // But first we want to strip the code's natural indentation
        &textwrap::dedent(
            // The definition _doesn't_ include the leading spaces, but we can
            // recover those from the column
            &format!("{}{definition}", " ".repeat(column - 1)),
        ),
        "    ",
    )
}

/// Creates a Nix path expression that when put into Nix file `from_file`, would point to the `to_file`.
fn create_path_expr(
    from_file: impl AsRef<RelativePath>,
    to_file: impl AsRef<RelativePath>,
) -> String {
    // This `expect` calls should never trigger because we only call this function with files.
    // That's why we `expect` them!
    let from = from_file.as_ref().parent().expect("a parent for this path");
    let rel = from.relative(to_file);
    format!("./{rel}")
}
