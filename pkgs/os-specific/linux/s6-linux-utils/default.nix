{ stdenv, fetchurl, skalibs }:

let

  version = "2.2.0.0";

in stdenv.mkDerivation rec {

  name = "s6-linux-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-linux-utils/${name}.tar.gz";
    sha256 = "1y9mva7wk1ca2djq3qjh7hz756zk57yv7ljdnldn7k7jzfmlaxsq";
  };

  dontDisableStatic = true;

  configureFlags = [
    "--enable-absolute-paths"
    "--includedir=\${prefix}/include"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ];

  meta = {
    homepage = http://www.skarnet.org/software/s6-linux-utils/;
    description = "A set of minimalistic Linux-specific system utilities";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
