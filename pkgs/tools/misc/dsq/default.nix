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
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "multiprocessio";
    repo = "dsq";
    rev = version;
    hash = "sha256-jwJw56Z/Y0vnsybE/FfXXHtz0W0J80Q5rrRRoINbjkM=";
  };

  vendorSha256 = "sha256-7KQDaDM151OFfTYRPOit4MAmwgEzvLOYFWCjXhVmFT0=";

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
