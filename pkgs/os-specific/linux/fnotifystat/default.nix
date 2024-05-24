{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "fnotifystat";
  version = "0.03.00";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-UGww0/m+JMftQyAguc8UpPrtIphjCq9TINabFaAKN0A=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "File activity monitoring tool";
    mainProgram = "fnotifystat";
    homepage = "https://github.com/ColinIanKing/fnotifystat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo dtzWill ];
  };
}
