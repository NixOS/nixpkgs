{
  lib,
  ghidra,
  gradle,
  fetchFromGitHub,
}:
let
  version = "0.4.0";
  self = ghidra.buildGhidraExtension {
    pname = "ghidra-delinker-extension";
    inherit version;

    src = fetchFromGitHub {
      owner = "boricj";
      repo = "ghidra-delinker-extension";
      rev = "04338fd028bf8b5449ff3f5373635111140bbeda";
      hash = "sha256-tfO92dnpfY13ZbvL36WzV/pC3xH/fbQDICNAF8D4fCI=";
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

    meta = {
      description = "Ghidra extension for delinking executables back to object files";
      homepage = "https://github.com/boricj/ghidra-delinker-extension";
      license = lib.licenses.asl20;
      maintainers = [ lib.maintainers.jchw ];
      platforms = lib.platforms.unix;
    };
  };
in
self
