{
  lib,
  ghidra,
  gradle,
  fetchFromGitHub,
}:
ghidra.buildGhidraExtension (finalAttrs: {
  pname = "ghidra-delinker-extension";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "boricj";
    repo = "ghidra-delinker-extension";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h6F50Z7S6tPOl9mIhChLKoFxHuAkq/n36ysUEFwWGxI=";
  };

  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail '"''${getGitHash()}"' '"v${finalAttrs.version}"'
  '';

  gradleBuildTask = "buildExtension";

  __darwinAllowLocalNetworking = true;

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  meta = {
    description = "Ghidra extension for delinking executables back to object files";
    homepage = "https://github.com/boricj/ghidra-delinker-extension";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jchw ];
    platforms = lib.platforms.unix;
  };
})
