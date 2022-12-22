{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, runCommand
, nix-update-script
, fetchurl
, testers
, python3
, curl
, jq
, p7zip
, dsq
}:

buildGoModule rec {
  pname = "dsq";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "multiprocessio";
    repo = "dsq";
    rev = "v${version}";
    hash = "sha256-FZBJe+2y4HV3Pgeap4yvD0a8M/j+6pAJEFpoQVVE1ec=";
  };

  vendorSha256 = "sha256-MbBR+OC1OGhZZGcZqc+Jzmabdc5ZfFEwzqP5YMrj6mY=";

  ldflags = [ "-X" "main.Version=${version}" ];

  checkInputs = [ python3 curl jq p7zip ];

  preCheck = ''
    substituteInPlace scripts/test.py \
      --replace 'dsq latest' 'dsq ${version}'
  '';

  checkPhase = ''
    runHook preCheck

    7z e testdata/taxi.csv.7z
    cp "$GOPATH/bin/dsq" .
    python3 scripts/test.py

    runHook postCheck
  '';

  passthru = {
    updateScript = nix-update-script { attrPath = pname; };

    tests.version = testers.testVersion { package = dsq; };
  };

  meta = with lib; {
    description = "Commandline tool for running SQL queries against JSON, CSV, Excel, Parquet, and more";
    homepage = "https://github.com/multiprocessio/dsq";
    license = licenses.asl20;
    maintainers = with maintainers; [ liff ];
  };
}
