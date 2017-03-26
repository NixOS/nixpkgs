{ stdenv, fetchurl, skalibs, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "s6-portable-utils-${version}";
  version = "2.1.0.0";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-portable-utils/${name}.tar.gz";
    sha256 = "0khw5ljmlghvl4hyrf4vd0hl5rrmsspchi8w4xgniwfip6vlbqfd";
  };

  dontDisableStatic = true;

  nativeBuildInputs = []
  ++ optional stdenv.isDarwin gcc;

  configureFlags = [
    "--enable-absolute-paths"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ];


  meta = {
    homepage = http://www.skarnet.org/software/s6-portable-utils/;
    description = "A set of tiny general Unix utilities optimized for simplicity and small size";
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };

}
