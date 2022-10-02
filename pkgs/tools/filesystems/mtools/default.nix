{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "mtools";
  version = "4.0.41";

  src = fetchurl {
    url = "mirror://gnu/mtools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-JUIVImT7Pv9+1wZiq/T07vgTO8N9C3pobCQN8rX4ChM=";
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
