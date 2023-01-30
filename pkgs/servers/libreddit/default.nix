{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "libreddit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kiiZxS5ttUZ1FdF/N9sO6GO13Wmij8DwsNa8p+ZTk0k=";
  };

  cargoSha256 = "sha256-0XBJ1tlVO2+iK9O2CDVZxDwFXW8T23j2lSbqpnW3fis=";

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
