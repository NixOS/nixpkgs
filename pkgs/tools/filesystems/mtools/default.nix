{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "mtools";
  version = "4.0.40";

  src = fetchurl {
    url = "mirror://gnu/mtools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-oi/KQjVAEd0ik6f1HyKLRuu9gC53QLCXWRKv7LedXfQ=";
  };

  patches = lib.optional stdenv.isDarwin ./UNUSED-darwin.patch;

  # fails to find X on darwin
  configureFlags = lib.optional stdenv.isDarwin "--without-x";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/mtools/";
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
