{ lib
, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "libreddit";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "spikecodes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NlAalhKsku9dJ3xZjXdI70QAltwWaHGLMYpWCRqU2Lk=";
  };

  cargoSha256 = "sha256-FzV61UtSn86llAlp4/ceVkFaN6W88OjrVsaLA7LoUhs=";

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
