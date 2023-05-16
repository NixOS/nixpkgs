{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "smemstat";
<<<<<<< HEAD
  version = "0.02.12";
=======
  version = "0.02.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
<<<<<<< HEAD
    hash = "sha256-5gO26F80nZvZ6RIqX8o7bDSNo38EL8XywR8wMPFqHA8=";
=======
    hash = "sha256-RvHBrcyNB/zqxEY27twgMsjHNg8kzJryqnIAM7+vpg8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Memory usage monitoring tool";
    homepage = "https://github.com/ColinIanKing/smemstat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
