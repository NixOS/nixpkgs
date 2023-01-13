{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "aoc-cli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "scarvalhojr";
    repo = pname;
    rev = version;
    hash = "sha256-oUvEZEnhYeAAZyLn2/isDZKT0+mhS5fnCvYGsR94uk0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-/76yzWPKGp4MEmFuvFJOMCxGKEdpohfzBAhRwvdEx8w=";

  meta = with lib; {
    description = "Advent of code command line tool";
    homepage = "https://github.com/scarvalhojr/aoc-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ jordanisaacs ];
  };
}
