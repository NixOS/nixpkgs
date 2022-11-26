{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LS9yUjKv0GxK6wGo0f5jHAn7vyo+tvgHd3NWLYpAQOs=";
  };

  cargoSha256 = "sha256-14tJLhWITCz/e+XuCww2GVZ+sXy08LQe+DpL4tkLUzE=";

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
