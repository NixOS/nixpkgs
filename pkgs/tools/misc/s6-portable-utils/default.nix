{ stdenv, fetchurl, skalibs }:

let

  version = "2.0.5.2";

in stdenv.mkDerivation rec {

  name = "s6-portable-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-portable-utils/${name}.tar.gz";
    sha256 = "0d5dvqz61abr4m2n10by8hccvw51jdvyckvpbbq0c57viri54jzm";
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
