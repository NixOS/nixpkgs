{stdenv, fetchurl, help2man}:

stdenv.mkDerivation {
  name = "fatsort";
  src = fetchurl {
    url = mirror://sourceforge/fatsort/fatsort-1.3.365.tar.gz;
    sha256 = "0g9zn2ns86g7zmy0y8hw1w1zhnd51hy8yl6kflyhxs49n5sc7b3p";
  };

  patches = [ ./fatsort-Makefiles.patch ];

  buildInputs = [ help2man ];

  meta = {
    homepage = http://fatsort.sourceforge.net/;
    description = "Sorts FAT partition table, for devices that don't do sorting of files.";
    maintainers = [ stdenv.lib.maintainers.kovirobi ];
    license = stdenv.lib.licenses.gpl2;
  };
}
