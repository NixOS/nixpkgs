{ stdenv, fetchurl, skalibs }:

let

  version = "2.0.0.0";

in stdenv.mkDerivation rec {

  name = "s6-dns-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-dns/${name}.tar.gz";
    sha256 = "07k6rzgsgcxr0bq209as79sjn2nrcjj9mlmk9vvy1hvsag0xnkcq";
  };

  dontDisableStatic = true;

  configureFlags = [
    "--includedir=\${prefix}/include"
    "--libdir=\${prefix}/lib"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ] ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ]);

  meta = {
    homepage = http://www.skarnet.org/software/s6-dns/;
    description = "A suite of DNS client programs and libraries for Unix systems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
