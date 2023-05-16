{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, inih, bash-completion }:

stdenv.mkDerivation rec {
  pname = "tio";
<<<<<<< HEAD
  version = "2.6";
=======
  version = "2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cYCkf9seaWcjrW0aDz+5FexfnTtiO3KQ1aX4OgG62Ug=";
  };

  strictDeps = true;

  buildInputs = [ inih ];

  nativeBuildInputs = [ meson ninja pkg-config bash-completion ];
=======
    hash = "sha256-7mVLfzguQ7eNIFTJMLJyoM+/pveGO88j2JUEOqvnqvk=";
  };

  nativeBuildInputs = [ meson ninja pkg-config inih bash-completion ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Serial console TTY";
    homepage = "https://tio.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.unix;
  };
}
