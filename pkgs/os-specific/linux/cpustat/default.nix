{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "cpustat";
<<<<<<< HEAD
  version = "0.02.19";
=======
  version = "0.02.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
<<<<<<< HEAD
    hash = "sha256-MujdgA+rFLrRc/N9yN7udnarA1TCzX//95hoXTUHG8Q=";
=======
    hash = "sha256-4HDXRtklzQSsywCGCTKdz6AtZta9R1mx7qkT7skX6Kc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
