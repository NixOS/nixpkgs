{ lib, stdenv, fetchFromGitHub, autoreconfHook, perl, readline }:

stdenv.mkDerivation rec {
  pname = "rlwrap";
<<<<<<< HEAD
  version = "0.46.1";
=======
  version = "0.46";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hanslub42";
    repo = "rlwrap";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-yKJXfdxfaCsmPtI0KmTzfFKY+evUuytomVrLsSCYDGo=";
=======
    rev = "v${version}";
    sha256 = "sha256-NlpVg1AimJn3VAbUl2GK1kaLkqU1Djw7/2Uc21AY0Jo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace src/readline.c \
      --replace "if(*p >= 0 && *p < ' ')" "if(*p >= 0 && (*p >= 0) && (*p < ' '))"
  '';

  nativeBuildInputs = [ autoreconfHook perl ];

  buildInputs = [ readline ];

  meta = with lib; {
    description = "Readline wrapper for console programs";
    homepage = "https://github.com/hanslub42/rlwrap";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
<<<<<<< HEAD
    maintainers = with maintainers; [ srapenne jlesquembre ];
=======
    maintainers = with maintainers; [ srapenne ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
