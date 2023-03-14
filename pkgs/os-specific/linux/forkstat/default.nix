{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "forkstat";
  version = "0.03.01";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-T7O+PIWmFC4wi4nnmNsAH8H0SazixBoCx5ZdBV2wL+E=";
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
