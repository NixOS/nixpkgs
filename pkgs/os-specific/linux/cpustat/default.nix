{ lib
, stdenv
, fetchFromGitHub
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "cpustat";
  version = "0.02.20";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo ="cpustat";
    rev = "refs/tags/V${version}";
    hash = "sha256-cdHoo2esm772q782kb7mwRwlPXGDNNLHJRbd2si5g7k=";
  };

  buildInputs = [
    ncurses
  ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "CPU usage monitoring tool";
    homepage = "https://github.com/ColinIanKing/cpustat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "cpustat";
  };
}
