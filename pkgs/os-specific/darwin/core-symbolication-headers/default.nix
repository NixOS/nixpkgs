{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "CoreSymbolication-headers";
  version = "0-unstable-2018-06-17";

  src = fetchFromGitHub {
    repo = "CoreSymbolication";
    owner = "matthewbauer";
    rev = "24c87c23664b3ee05dc7a5a87d647ae476a680e4";
    hash = "sha256-PzvLq94eNhP0+rLwGMKcMzxuD6MlrNI7iT/eV0obtSE=";
  };

  patches = [
    # Add missing symbol definitions needed to build `zlog` in system_cmds.
    # https://github.com/matthewbauer/CoreSymbolication/pull/2
    ./0001-Add-function-definitions-needed-to-build-zlog-in-sys.patch
    ./0002-Add-CF_EXPORT-To-const-symbols.patch
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/include/CoreSymbolication"
    cp *.h "$out/include/CoreSymbolication"
  '';

  meta = {
    description = "Reverse engineered headers for Apple's CoreSymbolication framework";
    homepage = "https://github.com/matthewbauer/CoreSymbolication";
    license = lib.licenses.mit;
    maintainers = lib.teams.darwin.members;
    platforms = lib.platforms.darwin;
  };
}
