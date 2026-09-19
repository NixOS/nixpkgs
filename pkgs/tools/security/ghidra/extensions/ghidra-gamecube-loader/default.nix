{
  lib,
  fetchFromGitHub,

  gradle,
  ghidra,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "ghidra-gamecube-loader";
  version = "0-unstable";

  src = fetchFromGitHub {
    owner = "Cuyler36";
    repo = "Ghidra-GameCube-Loader";
    rev = "0ff5e888526cd8cbc03660445c0dcd1105c8883a";
    hash = "sha256-kwgm3xf1VLm6N4icY2LHsL01mxqqR5djUd/Bw2hkFTg=";
  };

  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail \
        '-''${getGitHash()}' \
        '-${builtins.substring 0 8 finalAttrs.src.rev}'
    substituteInPlace data/buildLanguage.xml \
        --replace-fail \
        'file="../.antProperties.xml" optional="false"' \
        'file="../.antProperties.xml" optional="true"'
  '';

  configurePhase = ''
    runHook preConfigure

    pushd data
    touch sleighArgs.txt
    ant -f buildLanguage.xml -Dghidra.install.dir=${ghidra}/lib/ghidra sleighCompile
    popd

    runHook postConfigure
  '';

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  meta = {
    description = "A Nintendo GameCube binary loader for Ghidra";
    homepage = "https://github.com/Cuyler36/Ghidra-GameCube-Loader";
    downloadPage = "https://github.com/Cuyler36/Ghidra-GameCube-Loader/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jchw ];
  };
})
