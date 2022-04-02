{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.22.5";

  src = fetchFromGitHub {
    owner = "spikecodes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yzYmlewM9NcNHPUmfGiUP0Px2s+sagZOU82wK4973rY=";
  };

  cargoSha256 = "sha256-XZkTfpi9stW13l7yo0LFZryAPITVZa9MALrSWSei5LU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  passthru.tests = {
    inherit (nixosTests) libreddit;
  };

  meta = with lib; {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/spikecodes/libreddit";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab jojosch ];
  };
}
