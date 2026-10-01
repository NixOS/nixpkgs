{
  lib,
  mkMesonExecutable,

  nix-util,
  # Configuration Options

  version,
}:

let
  inherit (lib) fileset;
in

mkMesonExecutable (finalAttrs: {
  pname = "nix-nswrapper";
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
    nix-util
  ];

  mesonFlags = [
  ];

  meta = {
    mainProgram = "nix-nswrapper";
    platforms = lib.platforms.linux;
  };

})
