{ fetchurl, ncurses, stdenv,
  updateAutotoolsGnuConfigScriptsHook }:

stdenv.mkDerivation rec {
  name = "freesweep-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/rwestlund/freesweep/archive/v${version}.tar.gz";
    sha256 = "0l2kf14558lsq9qd2hs0kcyn9bbl1jdbzwrvcs6mnyjl7zpizcpj";
  };

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];
  buildInputs = [ ncurses ];

  preConfigure = ''
    configureFlags="$configureFlags --with-prefsdir=$out/share"
  '';

  installPhase = ''
    runHook preInstall
    install -D -m 0555 freesweep $out/bin/freesweep
    install -D -m 0444 sweeprc $out/share/sweeprc
    install -D -m 0444 freesweep.6 $out/share/man/man6/freesweep.6
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A console minesweeper-style game written in C for Unix-like systems";
    homepage = https://github.com/rwestlund/freesweep;
    license = licenses.gpl2;
    maintainers = with maintainers; [ kierdavis ];
    platforms = platforms.unix;
  };
}
