{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  name = "kore-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jorisvink";
    repo = "kore";
    rev = "${version}-release";
    sha256 = "1jjhx9gfjzpsrs7b9rgb46k6v03azrxz9fq7vkn9zyz6zvnjj614";
  };

  buildInputs = [ openssl ];

  postPatch = ''
    # Do not require kore to be on PATH when it launches itself as a subprocess.
    sed -ie "s+\"kore\"+\"$out/bin/kore\"+" src/cli.c
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An easy to use web application framework for C";
    homepage = https://kore.io;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ johnmh ];
  };
}
