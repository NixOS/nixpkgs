{stdenv, fetchurl, help2man}:

stdenv.mkDerivation rec {
  version = "1.5.0.456";
  pname = "fatsort";

  src = fetchurl {
    url = "mirror://sourceforge/fatsort/${pname}-${version}.tar.xz";
    sha256 = "15fy2m4p9s8cfvnzdcd5ynkc2js0zklkkf34sjxdac7x2iwb8dd8";
  };

  patches = [ ./fatsort-Makefiles.patch ];

  buildInputs = [ help2man ];

  meta = with stdenv.lib; {
    homepage = http://fatsort.sourceforge.net/;
    description = "Sorts FAT partition table, for devices that don't do sorting of files";
    maintainers = [ maintainers.kovirobi ];
    license = licenses.gpl2;
    inherit version;
    platforms = platforms.linux;
  };
}
