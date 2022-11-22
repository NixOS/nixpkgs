{ lib, buildNpmPackage, fetchFromGitHub, testers, mongosh }:

buildNpmPackage rec {
  pname = "mongosh";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    rev = "v${version}";
    hash = "sha256-Sfeu6uOHG3XMvpyc+zyrBKx1/+H9geYwTDHe2SAoH5s=";
  };

  npmDepsHash = "sha256-rnmEX8fxRLqlL09+Fs2kdsQPc1pir9exw2c7OEoV7sY=";

  patches = [
    # https://github.com/NixOS/nixpkgs/pull/203918#issuecomment-1334738506
    ./remove-mongodb-js-precommit.patch
  ];

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" "--verbose" ];

  passthru.tests.version = testers.testVersion {
    package = mongosh;
  };

  meta = with lib; {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "The MongoDB Shell";
    maintainers = with maintainers; [ aaronjheng ];
    license = licenses.asl20;
    mainProgram = "mongosh";
  };
}
