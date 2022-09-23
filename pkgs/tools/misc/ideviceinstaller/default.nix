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
  version = "1.1.1+date=2022-05-09";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "3909271599917bc4a3a996f99bdd3f88c49577fa";
    hash = "sha256-dw3nda2PNddSFPzcx2lv0Nh1KLFXwPBbDBhhwEaB6d0=";
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
