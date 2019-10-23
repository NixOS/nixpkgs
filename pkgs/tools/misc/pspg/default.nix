{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = version;
    sha256 = "1xiyshz56qpx3bv0mzx73rqr7wmyamyj8jbqdv05wjb72npkjmzl";
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
