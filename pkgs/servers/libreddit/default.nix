{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.14.14";

  src = fetchFromGitHub {
    owner = "spikecodes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-duirX+X8moByV1urdgXjzTQ2zOfCfz7etzjDxkSKvhk=";
  };

  cargoSha256 = "sha256-pFCERBnN386rW8ajpLWUHteCTWRmEiR19Sp5d8HXc5Y=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  passthru.tests = {
    inherit (nixosTests) libreddit;
  };

  meta = with lib; {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/spikecodes/libreddit";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
