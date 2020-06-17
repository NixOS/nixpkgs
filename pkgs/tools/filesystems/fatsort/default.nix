{stdenv, fetchurl, help2man}:

stdenv.mkDerivation rec {
  version = "1.6.2.605";
  pname = "fatsort";

  src = fetchurl {
    url = "mirror://sourceforge/fatsort/${pname}-${version}.tar.xz";
    sha256 = "1dzzsl3a1ampari424vxkma0i87qkbgkgm2169x9xf3az0vgmjh8";
  };

  patches = [ ./fatsort-Makefiles.patch ];

  buildInputs = [ help2man ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "http://fatsort.sourceforge.net/";
    description = "Sorts FAT partition table, for devices that don't do sorting of files";
    maintainers = [ maintainers.kovirobi ];
    license = licenses.gpl2;
    inherit version;
    platforms = platforms.linux;
  };
}
