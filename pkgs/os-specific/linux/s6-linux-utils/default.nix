{ stdenv
, fetchurl
, gnumake40
, skalibs
}:

let

  version = "2.0.0.0";

in stdenv.mkDerivation rec {

  name = "s6-linux-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-linux-utils/${name}.tar.gz";
    sha256 = "0lfgfwnk81vjlkvmr1gzknz9swgcrp5s7x19dfkw6shvi95fyirh";
  };

  dontDisableStatic = true;

  buildInputs = [ gnumake40 ];

  configureFlags = [
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
  };

}
