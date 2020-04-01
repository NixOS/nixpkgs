{ stdenv, fetchFromGitHub, rustPlatform }:

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

  cargoSha256 = "0fnkcjxcsiw9j0ibh4z7zy0m6r5d84q5hvr2darwpckbn9ryrh3k";

  meta = with stdenv.lib; {
    description = "Terminal-based personal organizer";
    homepage = https://github.com/spacejam/void;
    license = licenses.gpl3;
    maintainers = with maintainers; [ spacekookie ];
    platforms = platforms.all;
  };
}
