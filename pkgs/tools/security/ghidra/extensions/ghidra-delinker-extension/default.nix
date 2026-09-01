{
  callPackage,
  lib,
  ghidra,
  gradle,
  fetchFromGitHub,

  binary-file-toolkit ? callPackage ./binary-file-toolkit.nix { },
}:
ghidra.buildGhidraExtension (finalAttrs: {
  pname = "ghidra-delinker-extension";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "boricj";
    repo = "ghidra-delinker-extension";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wqxi/xF+HMG9wQUiHwilKX8PkdtHtGaNrXZyPMjT4iE=";
  };

  patches = [
    # The GitHub Maven repository is not available unauthenticated,
    # so patch in the dependency this way and replace the fake path
    # with the locally built derivation later.
    # The vendored-in dependency does not work for us because maven
    # needs to download dependencies while building.
    ./local-binary-file-toolkit.patch
  ];

  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail '"GIT_VERSION", gitVersionProvider' '"GIT_VERSION", "v${finalAttrs.version}"' \
      --replace-fail '"@binary-file-toolkit@"' '"${binary-file-toolkit}"'
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
