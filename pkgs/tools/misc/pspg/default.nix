{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "000h4yiaym7i5bcm268rvsjbs2brz2is9lhm6vm3dx0q7k1pcx45";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gnugrep ncurses readline postgresql ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jlesquembre ];
  };
}
