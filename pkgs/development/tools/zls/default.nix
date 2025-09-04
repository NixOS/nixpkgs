{
  lib,
  stdenv,
  zig_0_14,
  zig_0_15,
  fetchFromGitHub,
  callPackage,
}:

let
  common = finalAttrs: _: {
    pname = "zls";

    meta = {
      description = "Zig LSP implementation + Zig Language Server";
      mainProgram = "zls";
      changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
      homepage = "https://github.com/zigtools/zls";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        figsoda
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

    nativeBuildInputs = [ zig_0_14.hook ];

    postPatch = ''
      ln -s ${callPackage ./deps_0_14.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
    '';
  };

  zls_0_15 = finalAttrs: {
    version = "0.15.0";

    src = fetchFromGitHub {
      owner = "zigtools";
      repo = "zls";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-GFzSHUljcxy7sM1PaabbkQUdUnLwpherekPWJFxXtnk=";
    };

    nativeBuildInputs = [ zig_0_15.hook ];

    postPatch = ''
      ln -s ${callPackage ./deps_0_15.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
    '';
  };
}
