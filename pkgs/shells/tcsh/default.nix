{ lib
, stdenv
, fetchurl
, libxcrypt
, ncurses
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "tcsh";
  version = "6.24.07";

  src = fetchurl {
    url = "mirror://tcsh/${pname}-${version}.tar.gz";
    hash = "sha256-dOTpgFy9lBPtNLT/odcvyNDvgaW3lHaFQJFBbOkzaZU=";
  };

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    libxcrypt
    ncurses
  ];

  meta = with lib; {
    homepage = "https://www.tcsh.org/";
    description = "An enhanced version of the Berkeley UNIX C shell (csh)";
    longDescription = ''
      tcsh is an enhanced but completely compatible version of the Berkeley UNIX
      C shell, csh. It is a command language interpreter usable both as an
      interactive login shell and a shell script command processor.

      It includes:
      - command-line editor
      - programmable word completion
      - spelling correction
      - history mechanism
      - job control
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };

  passthru.shellPath = "/bin/tcsh";
}
