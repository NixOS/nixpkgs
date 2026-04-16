{
  lib,
  stdenv,
  zig_0_14,
  zig_0_15,
  zig_0_16,
  fetchFromGitHub,
  callPackage,
}:

let
  common = finalAttrs: _: {
    pname = "zls";

    strictDeps = true;

    zigBuildFlags = [
      "--system"
      "${finalAttrs.deps}"
    ];

    meta = {
      description = "Zig LSP implementation + Zig Language Server";
      mainProgram = "zls";
      changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
      homepage = "https://github.com/zigtools/zls";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        moni
        _0x5a4
        jmbaur
      ];
      platforms = lib.platforms.unix;
    };
  };
in
lib.mapAttrs (_: extension: stdenv.mkDerivation (lib.extends common extension)) {
  zls_0_14 = finalAttrs: {
    version = "0.14.0";

    src = fetchFromGitHub {
      owner = "zigtools";
      repo = "zls";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-A5Mn+mfIefOsX+eNBRHrDVkqFDVrD3iXDNsUL4TPhKo=";
    };

    deps = callPackage ./deps_0_14.nix { };

    nativeBuildInputs = [ zig_0_14 ];
  };

  zls_0_15 = finalAttrs: {
    version = "0.15.1";

    src = fetchFromGitHub {
      owner = "zigtools";
      repo = "zls";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-6IkRtQkn+qUHDz00QvCV/rb2yuF6xWEXug41CD8LLw8=";
    };

    deps = callPackage ./deps_0_15.nix { };

    nativeBuildInputs = [ zig_0_15 ];
  };

  zls_0_16 = finalAttrs: {
    version = "0.16.0";

    src = fetchFromGitHub {
      owner = "zigtools";
      repo = "zls";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-k0xWObsw9K12BKfK+UB5TieWDFEFfBQhN1X1NO35fWk=";
    };

    deps = callPackage ./deps_0_16.nix { };

    nativeBuildInputs = [ zig_0_16 ];
  };
}
