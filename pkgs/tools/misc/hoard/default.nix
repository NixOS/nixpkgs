{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "hoard";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Hyde46";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gm3X6/g5JQJEl7wRvWcO4j5XpROhtfRJ72LNaUeZRGc=";
  };

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-ZNhUqnsme1rczl3FdFBGGs+vBDFcFEELkPp0/udTfR4=";

  meta = with lib; {
    description = "CLI command organizer written in rust";
    homepage = "https://github.com/hyde46/hoard";
    license = licenses.mit;
    maintainers = with maintainers; [ builditluc ];
  };
}
