{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "12p95nybsisqpji01qgkp5wfg7fwk814xdsz338q9wac8nvqw9w3";
  };

  cargoSha256 = "13wfz0ig9dsl0h085rzlrx0dg9la957c50xyzjfxq1ybw2qr266b";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance Br1ght0ne ];
    platforms = with platforms; linux ++ darwin;
  };
}
