{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "hoard";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Hyde46";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WCyu6vW0l8J2Xh8OGXMXVDBs287m2nPlRHeA0j8uvlk=";
  };

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-Cku9NnrjWT7VmOCryb0sbCQibG+iU9CHT3Cvd6M/9f4=";

  meta = with lib; {
    description = "CLI command organizer written in rust";
    homepage = "https://github.com/hyde46/hoard";
    license = licenses.mit;
    maintainers = with maintainers; [ builditluc ];
  };
}
