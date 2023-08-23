{ lib
, stdenv
, fetchFromGitLab
, callPackage
, ensureNewerSourcesForZipFilesHook
, python3
# optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`
, extraTools ? []
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waf";
  version = "2.0.26";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = "waf-${finalAttrs.version}";
    hash = "sha256-AXDMWlwivJ0Xot6iwuIIlbV2Anz6ieghyOI9jA4yrko=";
  };

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    python3
  ];

  buildInputs = [
    # waf executable uses `#!/usr/bin/env python`
    python3
  ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    python waf-light configure

    runHook postConfigure
  '';

  buildPhase = let
    extraToolsList =
      lib.optionalString (extraTools != [])
        "--tools=\"${lib.concatStringsSep "," extraTools}\"";
  in
  ''
    runHook preBuild

    python waf-light build ${extraToolsList}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D waf $out/bin/waf

    runHook postInstall
  '';

  passthru = {
    inherit python3 extraTools;
    hook = callPackage ./hook.nix {
      waf = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://waf.io";
    description = "The meta build system";
    changelog  = "https://gitlab.com/ita1024/waf/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd3;
    mainProgram = "waf";
    maintainers = with lib.maintainers; [ AndersonTorres vrthra ];
    inherit (python3.meta) platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
