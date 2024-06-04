{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, e2fsprogs }:

stdenv.mkDerivation rec {
  pname = "e2tools";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "e2tools";
    repo = "e2tools";
    rev = "6ee7c2d9015dce7b90c3388096602e307e3bd790";
    sha256 = "0nlqynrhj6ww7bnfhhfcx6bawii8iyvhgp6vz60zbnpgd68ifcx7";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ e2fsprogs ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://e2tools.github.io/";
    description = "Utilities to read/write/manipulate files in an ext2/ext3 filesystem";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.leenaars ];
  };
}
