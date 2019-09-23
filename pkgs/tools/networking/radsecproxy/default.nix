{ stdenv, fetchFromGitHub, openssl, autoreconfHook, nettle }:

stdenv.mkDerivation rec {
  pname = "radsecproxy";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1268lbysa82b6h0101jzs0v6ixvmy3x0d0a8hw37sy95filsjmia";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl nettle ];

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
