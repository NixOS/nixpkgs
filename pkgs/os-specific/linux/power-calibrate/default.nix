{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "power-calibrate";
  version = "0.01.37";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-DZ6rXbhaSNy3TEX+lwv3tyKQ7BXOZ9ycrff/7pF60j0=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Tool to calibrate power consumption";
    mainProgram = "power-calibrate";
    homepage = "https://github.com/ColinIanKing/power-calibrate";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
