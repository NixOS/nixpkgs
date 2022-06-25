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
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "multiprocessio";
    repo = "dsq";
    rev = version;
    hash = "sha256-dgx1rFdhEtvyH/N3AtQE89ASBoE3CLl+ZFWwWWYe0II=";
  };

  vendorSha256 = "sha256-bLaBBWChK2RKXd/rX9m9UfHu8zt0j8TOm5S2M02U91A=";

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
    # TODO: Remove once nixpkgs uses macOS SDK 10.14+ for x86_64-darwin
    # Undefined symbols for architecture x86_64: "_SecTrustEvaluateWithError"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
