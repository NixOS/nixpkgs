<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitLab, python3, ensureNewerSourcesForZipFilesHook
# optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`
, withTools ? null
}:
let
  wafToolsArg = with lib.strings;
    optionalString (withTools != null) " --tools=\"${concatStringsSep "," withTools}\"";
in
stdenv.mkDerivation rec {
  pname = "waf";
  version = "2.0.25";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
<<<<<<< HEAD
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
=======
    rev = "${pname}-${version}";
    sha256 = "sha256-wqZEAfGRHhcd7Xm2pQ0FTjZGfuPafRrZAUdpc7ACoEA=";
  };

  nativeBuildInputs = [ python3 ensureNewerSourcesForZipFilesHook ];

  # waf bin has #!/usr/bin/env python
  buildInputs = [ python3 ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build${wafToolsArg}
  '';
  installPhase = ''
    install -D waf $out/bin/waf
  '';

  strictDeps = true;

  meta = with lib; {
    description = "Meta build system";
    homepage    = "https://waf.io";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
