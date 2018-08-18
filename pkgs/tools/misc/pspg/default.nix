{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline }:

stdenv.mkDerivation rec {
  name = "pspg-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = "${version}";
    sha256 = "172kphgy6rjs4np1azxldi6mcknjaksj7vfjs3ijldkzz87i7w95";
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
