{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "forkstat";
  version = "0.02.17";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-Rw1Xwst0+seksTLL+v3IUEojGjwCERwF89xkk70npUU=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Process fork/exec/exit monitoring tool";
    homepage = "https://github.com/ColinIanKing/forkstat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
