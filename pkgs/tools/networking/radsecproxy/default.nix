{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "radsecproxy-${version}";
  version = "1.6.9";

  src = fetchurl {
    url = "https://software.nordu.net/radsecproxy/radsecproxy-${version}.tar.xz";
    sha256 = "6f2c7030236c222782c9ac2c52778baa63540a1865b75a7a6d8c1280ce6ad816";
  };

  buildInputs = [ openssl ];

  configureFlags = [
     "--with-ssl=${openssl.dev}"
     "--sysconfdir=/etc"
     "--localstatedir=/var"
  ];

  meta = with stdenv.lib; {
    homepage = https://software.nordu.net/radsecproxy/;
    description = "A generic RADIUS proxy that supports both UDP and TLS (RadSec) RADIUS transports.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sargon ];
    platforms = with platforms; linux;
  };
}
