{lib, stdenv, fetchurl, help2man}:

stdenv.mkDerivation rec {
  version = "1.6.4.625";
  pname = "fatsort";

  src = fetchurl {
    url = "mirror://sourceforge/fatsort/${pname}-${version}.tar.xz";
    sha256 = "sha256-mm+JoGQLt4LYL/I6eAyfCuw9++RoLAqO2hV+CBBkLq0=";
  };

  patches = [ ./fatsort-Makefiles.patch ];

  buildInputs = [ help2man ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "http://fatsort.sourceforge.net/";
    description = "Sorts FAT partition table, for devices that don't do sorting of files";
    maintainers = [ maintainers.kovirobi ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
