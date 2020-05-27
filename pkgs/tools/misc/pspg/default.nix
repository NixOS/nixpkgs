{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "1hs1cixk1jcx8br81c4drm1b56hwcq6jiww0ywrpdna475jv5vvw";
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
