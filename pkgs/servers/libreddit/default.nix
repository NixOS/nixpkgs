{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0QWODM1YT11x/h7vMkgAjPSGkHrOOHyaF6CCvip1hMQ=";
  };

  cargoHash = "sha256-ri577SRLtx+5vazle8fqUL7Q75scAzvxUpAWl0Al6js=";

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
