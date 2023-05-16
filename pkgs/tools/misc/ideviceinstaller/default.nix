{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, usbmuxd
, libimobiledevice
, libzip
}:

stdenv.mkDerivation rec {
  pname = "ideviceinstaller";
<<<<<<< HEAD
  version = "1.1.1+date=2023-04-30";
=======
  version = "1.1.1+date=2022-05-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
<<<<<<< HEAD
    rev = "71ec5eaa30d2780c2614b6b227a2229ea3aeb1e9";
    hash = "sha256-YsQwAlt71vouYJzXl0P7b3fG/MfcwI947GtvN4g3/gM=";
=======
    rev = "3909271599917bc4a3a996f99bdd3f88c49577fa";
    hash = "sha256-dw3nda2PNddSFPzcx2lv0Nh1KLFXwPBbDBhhwEaB6d0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    usbmuxd
    libimobiledevice
    libzip
  ];

<<<<<<< HEAD
  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/ideviceinstaller";
    description = "List/modify installed apps of iOS devices";
    longDescription = ''
      ideviceinstaller is a tool to interact with the installation_proxy
      of an iOS device allowing to install, upgrade, uninstall, archive, restore
      and enumerate installed or archived apps.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aristid infinisil ];
  };
}
