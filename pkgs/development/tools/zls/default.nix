{
  lib,
  stdenv,
  zig_0_14,
  zig_0_15,
  fetchFromGitHub,
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

    zigDeps = zig_0_14.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-5ub+AA2PYuHrzPfouii/zfuFmQfn6mlMw4yOUDCw3zI=";
    };

    nativeBuildInputs = [ zig_0_14.hook ];
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

    zigDeps = zig_0_15.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-dy1V0DFXiHxJg397Wkx30scrhNoq5neYKMzu5QSrdjE=";
    };

    nativeBuildInputs = [ zig_0_15.hook ];
  };
}
