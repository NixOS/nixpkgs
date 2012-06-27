{ stdenv, fetchurl, openssl, libtool, perl, libxml2 }:

let
  version = "9.7.6-P1";
in
stdenv.mkDerivation rec {

  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "1xp7c3fpi3b6y1bz77mf7c98ic7rxp5lpwlmzqwsdrllip33qw1k";
  };

  patchPhase = ''
    sed -i 's/^\t.*run/\t/' Makefile.in
  '';

  buildInputs = [ openssl libtool perl libxml2 ];

  /* Why --with-libtool? */
  configureFlags = [ "--with-libtool" "--with-openssl=${openssl}"
    "--localstatedir=/var" ];
      
  meta = {
    homepage = http://www.isc.org/software/bind;
    description = "ISC BIND: a domain name server";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
