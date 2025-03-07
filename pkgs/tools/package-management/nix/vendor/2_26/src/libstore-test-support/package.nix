{
  lib,
  mkMesonLibrary,

  nix-util-test-support,
  nix-store,
  nix-store-c,

  rapidcheck,

  # Configuration Options

  version,
}:

let
  inherit (lib) fileset;
in

mkMesonLibrary (finalAttrs: {
  pname = "nix-store-test-support";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../nix-meson-build-support
    ./nix-meson-build-support
    ../../.version
    ./.version
    ./meson.build
    # ./meson.options
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
  ];

  propagatedBuildInputs = [
    nix-util-test-support
    nix-store
    nix-store-c
    rapidcheck
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
