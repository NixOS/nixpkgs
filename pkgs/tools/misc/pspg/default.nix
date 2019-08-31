{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = "${version}";
    sha256 = "1lwzyimn28a7q8k2c8z7and4qhrdil0za8lixh96z6x4lcb0rz5q";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnugrep ncurses readline ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/okbob/pspg;
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jlesquembre ];
  };
}
