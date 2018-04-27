{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline }:

stdenv.mkDerivation rec {
  name = "pspg-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = "${version}";
    sha256 = "10r6jfcqw4wclp84f07g3bda844csgm4sh7cjsnk2smmal7nhybs";
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
