{stdenv, fetchurl, help2man}:

stdenv.mkDerivation rec {
  version = "1.3.365";
  name = "fatsort-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fatsort/${name}.tar.gz";
    sha256 = "0g9zn2ns86g7zmy0y8hw1w1zhnd51hy8yl6kflyhxs49n5sc7b3p";
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
