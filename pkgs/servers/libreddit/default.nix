{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "spikecodes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G7QJhRmfqzDIfBHu8rSSMVlBoazY+0iDS7VJsmxaLqI=";
  };

  cargoSha256 = "sha256-xvPwzRGmRVe+Og78fKqcvf3I0uMR9DOdOXMNbuLI8sY=";

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
