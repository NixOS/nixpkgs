{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tmux-mem-cpu-load";
<<<<<<< HEAD
  version = "3.8.0";
=======
  version = "3.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "thewtex";
    repo = "tmux-mem-cpu-load";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dRHV2XF3NFzd4HT9SbRnEn8U40QTnAUJDsM51NA9fEk=";
=======
    sha256 = "sha256-4uSCYH31LO/69pxeur8byp9gYG6gaMYIiUxTmd7pag0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CPU, RAM, and load monitor for use with tmux";
    homepage = "https://github.com/thewtex/tmux-mem-cpu-load";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
  };
}
