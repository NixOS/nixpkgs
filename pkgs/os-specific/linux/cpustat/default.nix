{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "cpustat";
  version = "0.02.17";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-4HDXRtklzQSsywCGCTKdz6AtZta9R1mx7qkT7skX6Kc=";
  };

  buildInputs = [ ncurses ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "CPU usage monitoring tool";
    homepage = "https://github.com/ColinIanKing/cpustat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
