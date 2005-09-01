{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "eject-2.1.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.ibiblio.org/pub/Linux/utils/disk-management/eject-2.1.0.tar.gz;
    md5 = "82e3a7a4d7e3323018c6938015ff25f7";
  };
  buildInputs = [gettext];
  NIX_DEBUG=1;
  patches = [./eject-destdir.patch];
}
