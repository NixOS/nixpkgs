{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  version = "0.13";
  name = "litmus-${version}";

  src = fetchurl {
    url = http://webdav.org/neon/litmus/litmus-${version}.tar.gz;
    sha256 = "09d615958121706444db67e09c40df5f753ccf1fa14846fdeb439298aa9ac3ff";
  };
    
  buildInputs = [ openssl ];
  configureFlags = [ "--with-ssl" ];
  installFlags = [ "PREFIX=$(out)" ];
  
  meta = with stdenv.lib; {
    description = "WebDAV server protocol compliance test suite";
    long_description = ''litmus is a WebDAV server test suite, which aims to test whether a server is compliant with the WebDAV protocol as specified in RFC2518.'';
    homepage = "http://webdav.org/neon/litmus/";
    license = [ lib.licenses.gpl2 ];
    platforms = [ platforms.unix ];
    maintainers = [ maintainers.rkoe ];
  };
}
