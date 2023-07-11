{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "eventstat";
  version = "0.05.01";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-raODDA1EKtZThFg0NV6EfrWj5mSQNaiekywfOfAvYXI=";
  };

  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Simple monitoring of system events";
    homepage = "https://github.com/ColinIanKing/eventstat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
