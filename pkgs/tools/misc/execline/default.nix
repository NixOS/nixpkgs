{ stdenv
, fetchurl
, gnumake40
, skalibs
}:

let

  version = "2.0.0.0";

in stdenv.mkDerivation rec {

  name = "execline-${version}";

  src = fetchurl {
    url = "http://skarnet.org/software/execline/${name}.tar.gz";
    sha256 = "1g5v6icxsf7p2ccj9iq85iikkm12xph65ri86ydakihv6al3jw71";
  };

  dontDisableStatic = true;

  buildInputs = [ gnumake40 ];

  configureFlags = [
    "--libdir=\${prefix}/lib"
    "--includedir=\${prefix}/include"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ] ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ]);

  meta = {
    homepage = http://skarnet.org/software/execline/;
    description = "A small scripting language, to be used in place of a shell in non-interactive scripts";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
