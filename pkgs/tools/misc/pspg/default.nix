{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "0l20ysr61y99zxvm8cqsgj7arv4m7h7gqq8lrq65bmh9fxncfpsd";
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
