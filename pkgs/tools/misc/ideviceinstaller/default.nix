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
  version = "1.1.1+date=2023-04-30";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "71ec5eaa30d2780c2614b6b227a2229ea3aeb1e9";
    hash = "sha256-YsQwAlt71vouYJzXl0P7b3fG/MfcwI947GtvN4g3/gM=";
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

  # the package uses zip_get_num_entries, which is deprecated
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

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
    mainProgram = "ideviceinstaller";
  };
}
