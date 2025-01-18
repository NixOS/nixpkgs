{
  lib,
  ghidra,
  gradle,
  fetchFromGitHub,
}:
let
  version = "0.5.1";
  self = ghidra.buildGhidraExtension {
    pname = "ghidra-delinker-extension";
    inherit version;

    src = fetchFromGitHub {
      owner = "boricj";
      repo = "ghidra-delinker-extension";
      rev = "v${version}";
      hash = "sha256-h6F50Z7S6tPOl9mIhChLKoFxHuAkq/n36ysUEFwWGxI=";
    };

    postPatch = ''
      substituteInPlace build.gradle \
        --replace-fail '"''${getGitHash()}"' '"v${version}"'
    '';

    gradleBuildTask = "buildExtension";

    __darwinAllowLocalNetworking = true;

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    meta = with lib; {
      description = "Ghidra extension for delinking executables back to object files";
      homepage = "https://github.com/boricj/ghidra-delinker-extension";
      license = licenses.asl20;
      maintainers = [ maintainers.jchw ];
      platforms = platforms.unix;
    };
  };
in
self
