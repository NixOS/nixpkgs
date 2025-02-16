{
  lib,
  stdenv,
  mkMesonLibrary,

  nix-util,
  nix-store,
  nix-fetchers,
  nix-expr,
  nix-flake,
  nix-main,
  editline,
  readline,
  lowdown,
  nlohmann_json,

  # Configuration Options

  version,

  # Whether to enable Markdown rendering in the Nix binary.
  enableMarkdown ? !stdenv.hostPlatform.isWindows,

  # Which interactive line editor library to use for Nix's repl.
  #
  # Currently supported choices are:
  #
  # - editline (default)
  # - readline
  readlineFlavor ? if stdenv.hostPlatform.isWindows then "readline" else "editline",
}:

let
  inherit (lib) fileset;
in

mkMesonLibrary (finalAttrs: {
  pname = "nix-cmd";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../nix-meson-build-support
    ./nix-meson-build-support
    ../../.version
    ./.version
    ./meson.build
    ./meson.options
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
  ];

  buildInputs = [
    ({ inherit editline readline; }.${readlineFlavor})
  ] ++ lib.optional enableMarkdown lowdown;

  propagatedBuildInputs = [
    nix-util
    nix-store
    nix-fetchers
    nix-expr
    nix-flake
    nix-main
    nlohmann_json
  ];

  preConfigure =
    # "Inline" .version so it's not a symlink, and includes the suffix.
    # Do the meson utils, without modification.
    ''
      chmod u+w ./.version
      echo ${version} > ../../.version
    '';

  mesonFlags = [
    (lib.mesonEnable "markdown" enableMarkdown)
    (lib.mesonOption "readline-flavor" readlineFlavor)
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
