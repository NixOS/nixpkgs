{ lib
, stdenv
, fetchFromGitHub
, imlib2
, autoreconfHook
, autoconf-archive
, libX11
, libXext
, libXfixes
, libXcomposite
<<<<<<< HEAD
, libXinerama
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, libbsd
}:

stdenv.mkDerivation rec {
  pname = "scrot";
<<<<<<< HEAD
  version = "1.10";
=======
  version = "1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-ypPUQt3N30qUw5ecVRhwz3Hnh9lTOnbAm7o5tdxjyds=";
=======
    sha256 = "sha256-oVmEPkEK1xDcIRUQjCp6CKf+aKnnVe3L7aRTdSsCmmY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    imlib2
    libX11
    libXext
    libXfixes
    libXcomposite
<<<<<<< HEAD
    libXinerama
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libbsd
  ];

  meta = with lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "A command-line screen capture utility";
<<<<<<< HEAD
    mainProgram = "scrot";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mitAdvertising;
  };
}
