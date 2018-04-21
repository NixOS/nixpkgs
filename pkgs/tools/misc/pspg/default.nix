{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pspg-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = "${version}";
    sha256 = "1swrg4bg7i4xpdrsg8dsfldbxaffni04x8i1s0g6h691qcin675v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnugrep ncurses ];

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
