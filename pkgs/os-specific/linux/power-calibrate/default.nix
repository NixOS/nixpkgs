{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "power-calibrate";
  version = "0.01.34";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-T2fCTE+snNt1ylOpVR0JfT2x0lWrgItpfjtUx/zjaQw=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Tool to calibrate power consumption";
    homepage = "https://github.com/ColinIanKing/power-calibrate";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
