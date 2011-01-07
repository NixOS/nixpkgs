{ stdenv, fetchurl, openssl, libtool, perl, libxml2 }:

let
  version = "9.7.2-P3";
in
stdenv.mkDerivation rec {

  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "0zpvmgs75lisw746wccm2r428dmd4vv5s1pc512lyrmycr3mz56d";
  };

  buildInputs = [ openssl libtool perl libxml2 ];

  /* Why --with-libtool? */
  configureFlags = [ "--with-libtool" "--with-openssl=${openssl}" ];
      
  meta = {
    homepage = http://www.isc.org/software/bind;
    description = "ISC BIND: a domain name server";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
