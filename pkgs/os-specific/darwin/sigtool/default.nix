{ lib, stdenv, fetchFromGitHub, pkg-config, openssl }:

stdenv.mkDerivation rec {
  pname = "sigtool";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "sigtool";
    rev = "v${version}";
    sha256 = "sha256-GSVkF1BkZEkIF+q0SsoCuE0q48DRclE3E+qKc6JEc/0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];
}
