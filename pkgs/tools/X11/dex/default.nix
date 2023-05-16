<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, python3
, sphinx
}:
=======
{ lib, stdenv, fetchFromGitHub, python3 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "dex";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = pname;
    rev = "v${version}";
    sha256 = "03aapcywnz4kl548cygpi25m8adwbmqlmwgxa66v4156ax9dqs86";
  };

<<<<<<< HEAD
  strictDeps = true;

  nativeBuildInputs = [ sphinx ];
  buildInputs = [ python3 ];
=======
  propagatedBuildInputs = [ python3 ];
  nativeBuildInputs = [ python3.pkgs.sphinx ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  makeFlags = [ "PREFIX=$(out)" "VERSION=$(version)" ];

  meta = with lib; {
    description = "A program to generate and execute DesktopEntry files of the Application type";
    homepage = "https://github.com/jceb/dex";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ nickcao ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
