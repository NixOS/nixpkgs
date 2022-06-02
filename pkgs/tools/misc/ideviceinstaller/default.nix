{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, usbmuxd, libzip, libimobiledevice }:

stdenv.mkDerivation rec {
  pname = "ideviceinstaller";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    sha256 = "1xp0sjgfx2z19x9mxihn18ybsmrnrcfc55zbh5a44g3vrmagmlzz";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config usbmuxd libimobiledevice libzip ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/ideviceinstaller";
    description = "List/modify installed apps of iOS devices";
    longDescription = ''
      ideviceinstaller is a tool to interact with the installation_proxy
      of an iOS device allowing to install, upgrade, uninstall, archive, restore
      and enumerate installed or archived apps.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ aristid infinisil ];
  };
}
