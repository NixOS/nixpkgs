{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qO9AgEAm+wK8LAlUOYIKYTXJYT3yz65UWAFTf711+5w=";
  };

  cargoSha256 = "sha256-ApZLYKavYt1Zp7qvdbhBXPBj7qv/D/oZp5lK2sfWnDI=";

  buildInputs = lib.optional stdenv.isDarwin [
    Security
  ];

  passthru.tests = {
    inherit (nixosTests) libreddit;
  };

  meta = with lib; {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/libreddit/libreddit";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab jojosch ];
  };
}
