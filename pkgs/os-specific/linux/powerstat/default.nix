{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "powerstat";
<<<<<<< HEAD
  version = "0.03.03";
=======
  version = "0.03.01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
<<<<<<< HEAD
    hash = "sha256-D8VwczXHUHQ8p03IgYW3t8hOIGHKp0n1c7FpAUWua74=";
=======
    hash = "sha256-+3b6yH5CuFdtjjTmW2mwuvNyhO8/8N7vv6st+ttztBQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Laptop power measuring tool";
    homepage = "https://github.com/ColinIanKing/powerstat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
