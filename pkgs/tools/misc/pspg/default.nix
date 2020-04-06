{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "1fq8n5naicfv0lsyzfb52c84w40zrsks0x9rrvyyzih4vkhic4vm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnugrep ncurses readline postgresql ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jlesquembre ];
  };
}
