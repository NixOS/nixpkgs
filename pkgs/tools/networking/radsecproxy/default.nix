{ lib, stdenv, fetchFromGitHub, openssl, autoreconfHook, nettle }:

stdenv.mkDerivation rec {
  pname = "radsecproxy";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-gSXjwQ9zJPVNzGqLsZzTEQ0OxbQUiUJYGxrEm56DZDE=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl nettle ];

  configureFlags = [
     "--with-ssl=${openssl.dev}"
     "--sysconfdir=/etc"
     "--localstatedir=/var"
  ];

  meta = with lib; {
    homepage = "https://radsecproxy.github.io/";
    description = "A generic RADIUS proxy that supports both UDP and TLS (RadSec) RADIUS transports";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sargon ];
    platforms = with platforms; linux;
  };
}
