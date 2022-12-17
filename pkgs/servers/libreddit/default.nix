{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/K79EHjqkclyh1AmRaevYcyUD4XSrTfd5zjnpOmBNcE=";
  };

  cargoSha256 = "sha256-KYuEy5MwgdiHHbDDNyb+NVYyXdvx1tCH7dQdPWCCfQo=";

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
