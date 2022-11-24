{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I/LPCPAZLltb55TBBS3NE2oU97Dx3L/dHLaEVkVBTGA=";
  };

  cargoSha256 = "sha256-0Udwnvf60sumAeGtaxyiHbkWYMvNjwcWX9W1m3CUvb8=";

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
