{ lib
, stdenv
, meson
, ninja
, pkg-config
, ncurses
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "loksh";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-q5RiY9/xEFCk+oHlxgNwDOB+TNjRWHKzU2kQH2LjCWY=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  postInstall = ''
    mv $out/bin/ksh $out/bin/loksh
    mv $out/share/man/man1/ksh.1 $out/share/man/man1/loksh.1
    mv $out/share/man/man1/sh.1 $out/share/man/man1/loksh-sh.1
  '';

  passthru = {
    shellPath = "/bin/loksh";
  };

  meta = with lib; {
    description = "Linux port of OpenBSD's ksh";
    homepage = "https://github.com/dimkr/loksh";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ cameronnemo ];
    platforms = platforms.linux;
  };
}
