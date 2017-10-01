{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation {
  name = "kore-2.0.0";

  src = fetchFromGitHub {
    owner = "jorisvink";
    repo = "kore";
    rev = "2.0.0-release";
    sha256 = "1jjhx9gfjzpsrs7b9rgb46k6v03azrxz9fq7vkn9zyz6zvnjj614";
  };

  buildInputs = [ openssl ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "An easy to use web application framework for C";
    homepage = https://kore.io;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ johnmh ];
  };
}
