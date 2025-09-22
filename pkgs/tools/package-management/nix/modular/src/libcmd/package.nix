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

mkMesonLibrary (finalAttrs: {
  pname = "nix-cmd";
  inherit version;

  workDir = ./.;

  buildInputs = [
    ({ inherit editline readline; }.${readlineFlavor})
  ]
  ++ lib.optional enableMarkdown lowdown;

  propagatedBuildInputs = [
    nix-util
    nix-store
    nix-fetchers
    nix-expr
    nix-flake
    nix-main
    nlohmann_json
  ];

  mesonFlags = [
    (lib.mesonEnable "markdown" enableMarkdown)
    (lib.mesonOption "readline-flavor" readlineFlavor)
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
