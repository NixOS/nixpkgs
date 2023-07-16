{ lib
, stdenv
, fetchFromGitLab
, ensureNewerSourcesForZipFilesHook
, python3
# optional list of extra waf tools, e.g. `[ "doxygen" "pytest" ]`
, extraTools ? []
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waf";
  version = "2.0.25";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = "waf-${finalAttrs.version}";
    hash = "sha256-wqZEAfGRHhcd7Xm2pQ0FTjZGfuPafRrZAUdpc7ACoEA=";
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

  meta = {
    homepage = "https://waf.io";
    changelog  = "https://gitlab.com/ita1024/waf/blob/${finalAttrs.version}/ChangeLog";
    description = "The meta build system";
    license = lib.licenses.bsd3;
    mainProgram = "waf";
    maintainers = with lib.maintainers; [ AndersonTorres vrthra ];
    inherit (python3.meta) platforms;
  };
})
