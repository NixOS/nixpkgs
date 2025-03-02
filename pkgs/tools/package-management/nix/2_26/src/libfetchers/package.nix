{
  lib,
  mkMesonLibrary,

  nix-util,
  nix-store,
  nlohmann_json,
  libgit2,

  # Configuration Options

  version,
}:

let
  inherit (lib) fileset;
in

mkMesonLibrary (finalAttrs: {
  pname = "nix-fetchers";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../nix-meson-build-support
    ./nix-meson-build-support
    ../../.version
    ./.version
    ./meson.build
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
  ];

  buildInputs = [
    libgit2
  ];

  propagatedBuildInputs = [
    nix-store
    nix-util
    nlohmann_json
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
