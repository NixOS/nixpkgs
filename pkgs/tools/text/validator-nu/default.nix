{
  fetchFromGitHub,
  git,
  jdk_headless,
  jre_headless,
  makeWrapper,
  python3,
  stdenvNoCC,
  lib,
  testers,
}:

let
  pname = "validator-nu";
  version = "23.4.11-unstable-2023-12-18";

  src = fetchFromGitHub {
    owner = "validator";
    repo = "validator";
    rev = "c3a401feb6555affdc891337f5a40af238f9ac2d";
    fetchSubmodules = true;
    hash = "sha256-pcA3HXduzFKzoOHhor12qvzbGSSvo3k3Bpy2MvvQlCI=";
  };

  deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-deps";
    inherit version src;

    nativeBuildInputs = [
      git
      jdk_headless
      python3
      python3.pkgs.certifi
    ];

    buildPhase = ''
      python checker.py dldeps
    '';

    installPhase = ''
      mkdir "$out"
      mv dependencies extras "$out"
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-LPtxpUd7LAYZHJL7elgcZOTaTgHqeqquiB9hiuajA6c=";
  };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    git
    jdk_headless
    makeWrapper
    python3
  ];

  postPatch = ''
    substituteInPlace build/build.py --replace-warn \
      'validatorVersion = "%s.%s.%s" % (year, month, day)' \
      'validatorVersion = "${finalAttrs.version}"'
  '';

  buildPhase = ''
    ln -s '${deps}/dependencies' '${deps}/extras' .
    JAVA_HOME='${jdk_headless}' python checker.py build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/java"
    mv build/dist/vnu.jar "$out/share/java/"
    makeWrapper "${jre_headless}/bin/java" "$out/bin/vnu" \
      --add-flags "-jar '$out/share/java/vnu.jar'"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Helps you catch problems in your HTML/CSS/SVG";
    homepage = "https://validator.github.io/validator/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      andersk
      ivan
    ];
    mainProgram = "vnu";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      fromSource
    ];
  };
})
