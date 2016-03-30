{ stdenv, fetchurl, skalibs }:

let

  version = "2.0.5.3";

in stdenv.mkDerivation rec {

  name = "s6-portable-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-portable-utils/${name}.tar.gz";
    sha256 = "029fg9c37vwh9yagd69h8r192nrx4mfva8dwgpm1gxkdssrh3gi7";
  };

  dontDisableStatic = true;

  configureFlags = [
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ];

  meta = {
    homepage = http://www.skarnet.org/software/s6-portable-utils/;
    description = "A set of tiny general Unix utilities optimized for simplicity and small size";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
