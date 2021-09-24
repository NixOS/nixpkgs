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

  # Sigtool needs filesystem support.
  # We need to be able to build sigtool on x86 so we can build the cross bootstrap tools.
  NIX_LDFLAGS = lib.optionals (stdenv.cc.isClang && lib.versionOlder stdenv.cc.version "9") [
    "-lc++fs"
  ];

  installFlags = [ "PREFIX=$(out)" ];
}
