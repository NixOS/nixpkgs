{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "spikecodes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+oROogXovkHLjLf5KLrolF2AzTd3krXMMzUyiCIHrgE=";
  };

  cargoSha256 = "sha256-JixEh9xmWzKwC7Rr5xVmRFrGbgqvbxqIGKmGGSeLllQ=";

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
