{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_17,
}:
let
  common = finalAttrs: _: {
    pname = "zigscient";

    strictDeps = true;
    __structuredAttrs = true;

    zigBuildFlags = [
      "--system"
      "${finalAttrs.deps}"
      "-Doptimize=ReleaseFast"
    ];
    preBuild = ''
      export ZIG_DEBUG_CMD=1;
      export ZIG_LIB_DIR=./lib;
    '';

    meta = {
      description = "Zig Language Server - A drop-in alternative to ZLS";
      mainProgram = "zigscient";
      homepage = "https://github.com/llogick/zigscient";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        alorans
      ];
      platforms = lib.platforms.unix;
    };
  };
in
lib.mapAttrs (_: extension: stdenv.mkDerivation (lib.extends common extension)) {
  zigscient_0_17 = finalAttrs: {
    version = "0.17.0";
    deps = callPackage ./deps_0_17.nix { };
    nativeBuildInputs = [ zig_0_17 ];

    src = fetchFromGitHub {
      owner = "llogick";
      repo = "zigscient";
      rev = "c62e83f67dfbe97b1fb1d5b5a06ec4af9bf0ad90";
      hash = "sha256-tWgUZm9kW8B/tCIx5g2N4mVRiqKxLy+YuxBv0iSvLds=";
    };
  };
}
