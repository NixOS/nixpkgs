{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "void";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "spacejam";
    repo = "void";
    rev = version;
    sha256 = "08vazw4rszqscjz988k89z28skyj3grm81bm5iwknxxagmrb20fz";
  };

  # The tests are long-running and not that useful
  doCheck = false;

  cargoSha256 = "1wh1yb02w5afghd19i2s0v8mq4lq20djsljrr44xciq68bqfdcp0";

  meta = with lib; {
    description = "Terminal-based personal organizer";
    homepage = "https://github.com/spacejam/void";
    license = licenses.gpl3;
    maintainers = with maintainers; [ spacekookie ];
    mainProgram = "void";
  };
}
