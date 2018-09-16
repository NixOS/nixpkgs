{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, ncurses
, withGtk ? false, gtk2 ? null }:

assert withGtk -> gtk2 != null;

stdenv.mkDerivation rec {
  name="mtr-${version}";
  version="0.92";

  src = fetchFromGitHub {
    owner  = "traviscross";
    repo   = "mtr";
    rev    = "v${version}";
    sha256 = "0ca2ml846cv0zzkpd8y7ah6i9b3czrr8wlxja3cray94ybwb294d";
  };

  preConfigure = ''
    echo ${version} > .tarball-version

    ./bootstrap.sh

    substituteInPlace Makefile.in --replace ' install-exec-hook' ""
  '';

  configureFlags = stdenv.lib.optional (!withGtk) "--without-gtk";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ncurses ] ++ stdenv.lib.optional withGtk gtk2;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A network diagnostics tool";
    homepage    = http://www.bitwizard.nl/mtr/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ koral orivej raskin ];
    platforms   = platforms.unix;
  };
}
