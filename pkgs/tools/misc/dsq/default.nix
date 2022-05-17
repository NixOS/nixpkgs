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
, dsq
}:

buildGoModule rec {
  pname = "dsq";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "multiprocessio";
    repo = "dsq";
    rev = version;
    hash = "sha256-emBLYiNOHYp3XsaY172DDtIdquj3U3U/Q6bogC3rvFQ=";
  };

  vendorSha256 = "sha256-ZZDZ3FWgOpRJB+X1hrlP8Hh1n3l7jUd39H5MDz88wOs=";

  ldflags = [ "-X" "main.Version=${version}" ];

  checkInputs = [ python3 curl jq ];

  preCheck =
    let
      taxiCsv = fetchurl {
        url = "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-04.csv";
        hash = "sha256-CXJPraOYAy5tViDcBi9gxI/rJ3ZXqOa/nJ/d+aREV+M=";
      };
    in
    ''
      substituteInPlace scripts/test.py \
        --replace '${taxiCsv.url}' file://${taxiCsv} \
        --replace 'dsq latest' 'dsq ${version}'
    '';

  checkPhase = ''
    runHook preCheck

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
    # TODO: Remove once nixpkgs uses macOS SDK 10.14+ for x86_64-darwin
    # Undefined symbols for architecture x86_64: "_SecTrustEvaluateWithError"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
