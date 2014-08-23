{stdenv, fetchurl, openssl, lzo, zlib, yacc, flex }:
stdenv.mkDerivation {
  name = "vtun-3.0.1";

  src = fetchurl {
    url = mirror://sourceforge/vtun/vtun-3.0.1.tar.gz;
    sha256 = "1sxf9qq2wlfh1wnrlqkh801v1m9jlqpycxvr2nbyyl7nm2cp8l12";
  };

  patchPhase = ''
    sed -i -e 's/-m 755//' -e 's/-o root -g 0//' Makefile.in 
  '';
  buildInputs = [ lzo openssl zlib yacc flex ];

  configureFlags = ''
    --with-lzo-headers=${lzo}/include/lzo
    --with-ssl-headers=${openssl}/include/openssl
    --with-blowfish-headers=${openssl}/include/openssl'';

  meta = { 
      description="Virtual Tunnels over TCP/IP with traffic shaping, compression and encryption";
      homepage="http://vtun.sourceforge.net/";
      license = stdenv.lib.licenses.gpl2;
  };
}
