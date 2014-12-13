{ stdenv, fetchurl, openssl, expat, libevent }:

stdenv.mkDerivation rec {
  name = "unbound-1.5.1";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "1v00k4b6m9wk0533s2jpg4rv9lhplh7zdp6vx2yyrmrbzc4jgy0g";
  };

  buildInputs = [ openssl expat libevent ];

  configureFlags =
    [ "--with-ssl=${openssl}"
      "--with-libexpat=${expat}"
      "--localstatedir=/var"
    ];

  meta = with stdenv.lib;
    {  description = "Validating, recursive, and caching DNS resolver";
       homepage = http://www.unbound.net;
       license = licenses.bsd3;
       maintainers = [ maintainers.emery ];
       platforms = platforms.unix;
    };
}
