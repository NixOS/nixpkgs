{ stdenv, fetchurl, apacheHttpd }:

stdenv.mkDerivation {
  name = "mod_evasive-1.10.1";

  src = fetchurl {
    url = http://www.zdziarski.com/blog/wp-content/uploads/2010/02/mod_evasive_1.10.1.tar.gz;
    sha256 = "0rsnx50rjv6xygbp9r0gyss7xqdkcb0hy3wh9949jf1im8wm3i07";
  };

  buildInputs = [ apacheHttpd ];

  buildPhase = ''
    export APACHE_LIBEXECDIR=$out/modules
    export makeFlagsArray=(APACHE_LIBEXECDIR=$out/modules)
    apxs -ca mod_evasive20.c
  '';

  installPhase = ''
    mkdir -p $out/modules
    cp .libs/mod_evasive20.so $out/modules
  '';

  meta = {
    homepage = "http://www.zdziarski.com/blog/?page_id=442";
    description = "Evasive maneuvers module for Apache to provide evasive action in the event of an HTTP DoS or DDoS attack or brute force attack";
    platforms = stdenv.lib.platforms.linux;
  };
}
