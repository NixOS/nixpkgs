{
  lib,
  stdenv,
  zig_0_14,
  zig_0_15,
  zig_0_16,
  zig_0_17,
  fetchFromGitHub,
}:

let
  common = finalAttrs: _: {
    pname = "zls";

    strictDeps = true;

    postConfigure = ''
      ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    '';

    __structuredAttrs = true;

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

    zigDeps = zig_0_14.fetchDeps {
      inherit (finalAttrs) src pname version;
      hash = "sha256-5ub+AA2PYuHrzPfouii/zfuFmQfn6mlMw4yOUDCw3zI=";
    };

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

    zigDeps = zig_0_15.fetchDeps {
      inherit (finalAttrs) src pname version;
      fetchAll = true;
      hash = "sha256-dy1V0DFXiHxJg397Wkx30scrhNoq5neYKMzu5QSrdjE=";
    };

    nativeBuildInputs = [ zig_0_15 ];
  };

  zls_0_16 = finalAttrs: {
    version = "0.16.1";

    src = fetchFromGitHub {
      owner = "zigtools";
      repo = "zls";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-ey+np/OPOXy2C9aJbNQXdAcpcLHBUfqGMcjzfL0Ni1c=";
    };

    zigDeps = zig_0_16.fetchDeps {
      inherit (finalAttrs) src pname version;
      fetchAll = true;
      hash = "sha256-9wkFYhezPx9Kyv1qh9ZWACSzbZAIWe1DavxfOac/l0c=";
    };

    nativeBuildInputs = [ zig_0_16 ];
  };

  zls_0_17 = finalAttrs: {
    version = "0.17.0";

    src = fetchFromGitHub {
      owner = "zigtools";
      repo = "zls";
      tag = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-T9M+HveJagHY6EMvwpwlF9TrxmliefkuZ0NZ5Z1Ar90=";
    };

    zigDeps = zig_0_17.fetchDeps {
      inherit (finalAttrs) src pname version;
      fetchAll = true;
      hash = "sha256-c6kXNUY74NYFsvnvmyawKogDkJA0OueF9lOaPyQMIGg=";
    };

    nativeBuildInputs = [ zig_0_17 ];
  };
}
