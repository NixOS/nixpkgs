{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "fnotifystat";
  version = "0.02.10";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-bcb1kSpNZV7eTcEIcaoiqxB68kTc0TGFMIr1Aehy/Rc=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "File activity monitoring tool";
    homepage = "https://github.com/ColinIanKing/fnotifystat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo dtzWill ];
  };
}
