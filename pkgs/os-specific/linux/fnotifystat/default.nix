{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fnotifystat";
  version = "0.02.07";
  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    sha256 = "sha256-5oYM1t+vmWywYRbgXI2RGQlOuNJluj2gwCMf3pTpDC0=";
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
