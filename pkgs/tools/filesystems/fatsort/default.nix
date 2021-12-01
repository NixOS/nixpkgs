{lib, stdenv, fetchurl, help2man}:

stdenv.mkDerivation rec {
  version = "1.6.3.622";
  pname = "fatsort";

  src = fetchurl {
    url = "mirror://sourceforge/fatsort/${pname}-${version}.tar.xz";
    sha256 = "1z2nabm38lg56h05yx3jjsndbqxk1zbjcisrczzamypn13m98728";
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
