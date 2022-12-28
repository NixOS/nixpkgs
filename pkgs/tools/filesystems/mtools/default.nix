{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "mtools";
  version = "4.0.42";

  src = fetchurl {
    url = "mirror://gnu/mtools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ZL/f3k2Cr2si88HHLD4jHLthj0wjCcxG9U0W1VAszxU=";
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
