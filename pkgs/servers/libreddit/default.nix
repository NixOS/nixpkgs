{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gwI2ASJkHc2kOmC4D65Te7iz0Kozm8bpq2MUYZRBdtk=";
  };

  cargoSha256 = "sha256-9NkWYurq7S4ysnP7oLoggMNAIFay5qVWcuer4EOrQEA=";

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
