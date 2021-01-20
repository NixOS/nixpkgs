{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mtools";
  version = "4.0.26";

  src = fetchurl {
    url = "mirror://gnu/mtools/${pname}-${version}.tar.bz2";
    sha256 = "06pabnjc4r2vv3dzfm6q97g6jbp2k5bhmcdwv2cf25ka8y5ir7sk";
  };

  patches = lib.optional stdenv.isDarwin ./UNUSED-darwin.patch;

  # fails to find X on darwin
  configureFlags = lib.optional stdenv.isDarwin "--without-x";

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/mtools/";
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
