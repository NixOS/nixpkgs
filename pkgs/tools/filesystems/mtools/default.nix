{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mtools";
  version = "4.0.35";

  src = fetchurl {
    url = "mirror://gnu/mtools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-NHaeFzdR0vDYkaCMdsgEJ+kpuO5DQ4AZuGZsw9ekR0k=";
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
