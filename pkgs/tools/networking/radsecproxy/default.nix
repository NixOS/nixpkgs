{ stdenv, fetchFromGitHub, openssl, autoreconfHook, nettle }:

stdenv.mkDerivation rec {
  pname = "radsecproxy";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1g7q128cip1dac9jad58rd96afx4xz7x7vsiv0af8iyq2ivqvs2m";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl nettle ];

  configureFlags = [
     "--with-ssl=${openssl.dev}"
     "--sysconfdir=/etc"
     "--localstatedir=/var"
  ];

  meta = with stdenv.lib; {
    homepage = "https://software.nordu.net/radsecproxy/";
    description = "A generic RADIUS proxy that supports both UDP and TLS (RadSec) RADIUS transports";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sargon ];
    platforms = with platforms; linux;
  };
}
