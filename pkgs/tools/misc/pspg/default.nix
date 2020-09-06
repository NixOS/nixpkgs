{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "16pajhzr4aahyhdzkp9g3ld2insnlk2z2w2pfab8bghw4f69j5xf";
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
