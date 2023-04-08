{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "biscuit-cli";
  version = "0.2.0-next-pre20230103";

  src = fetchFromGitHub {
    owner = "biscuit-auth";
    repo = "biscuit-cli";
    rev = "0ecf1ec4c98a90b1bf3614558a029b47c57288df";
    sha256 = "sha256-ADJWqx70IwuvCBeK9rb9WBIsD+oQROQSduSQ8Bu8mfk=";
  };

  cargoLock = {
    outputHashes."biscuit-auth-3.0.0-alpha4" = "sha256-4SzOupoD33D0KHZyVLriGzUHy9XXnWK1pbgqOjJH4PI=";
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "CLI to generate and inspect biscuit tokens";
    homepage = "https://www.biscuitsec.org/";
    maintainers = [ lib.maintainers.shlevy ];
    license = lib.licenses.bsd3;
  };
}
