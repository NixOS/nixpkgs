{ lib
, fetchFromGitHub
, buildGoModule
, leveldb
, geos
}:

buildGoModule rec {
  pname = "imposm";
  version = "0.11.1-unstable-2022-08-23";

  src = fetchFromGitHub {
    owner = "omniscale";
    repo = "imposm3";
    rev = "33e15acf7b3e0df1c4af25c5eda312842ef0cbb4";
    hash = "sha256-ZtXmKS2ili3/StaHDq+s2ReKm7KtzPBH+ssbJHG3NF4=";
  };

  # Dependencies are vendored.
  vendorHash = null;

  buildInputs = [
    leveldb
    geos
  ];

  buildPhase = ''
    runHook preBuild

    make GO_LDFLAGS="-s -w" BUILD_REV=${src.rev} BUILD_BRANCH=master TAG=${version} imposm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 imposm -t $out/bin

    runHook postInstall
  '';

  # Tests require osmosis.
  doCheck = false;

  meta = with lib; {
    description = "Importer for OpenStreetMap data";
    homepage = "http://imposm.org/docs/imposm3/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
