{ stdenv, fetchFromGitHub, openssl, autoreconfHook, nettle }:

stdenv.mkDerivation rec {
  pname = "radsecproxy";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "12pvwd7v3iswki3riycxaiiqxingg4bqnkwc5ay3j4n2kzynr1qg";
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
    description = "A generic RADIUS proxy that supports both UDP and TLS (RadSec) RADIUS transports.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sargon ];
    platforms = with platforms; linux;
  };
}
