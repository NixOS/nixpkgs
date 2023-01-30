{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3Q/Vl126EMRSNdStpZqFEkA0Kjzu6BeyBhokTQrrQXE=";
  };

  cargoSha256 = "sha256-TA0Rsya3vx6N/iAWpRmB7Byz7AIR0sdfk3kJ8wgvWHY=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  passthru.tests = {
    inherit (nixosTests) libreddit;
  };

  meta = with lib; {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/libreddit/libreddit";
    changelog = "https://github.com/libreddit/libreddit/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab jojosch ];
  };
}
