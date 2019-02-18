{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, usbmuxd, libzip, libimobiledevice }:

stdenv.mkDerivation rec {
  pname = "ideviceinstaller";
  version = "2018-06-01";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "f7988de8279051f3d2d7973b8d7f2116aa5d9317";
    sha256 = "1vmdvbwnjz3f90b9bqq7jg04q7awsbi9pmkvgwal8xdpp6jcwkwx";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig usbmuxd libimobiledevice libzip ];

  meta = with stdenv.lib; {
    homepage = https://github.com/libimobiledevice/ideviceinstaller;
    description = "List/modify installed apps of iOS devices";
    longDescription = ''
      ideviceinstaller is a tool to interact with the installation_proxy 
      of an iOS device allowing to install, upgrade, uninstall, archive, restore
      and enumerate installed or archived apps.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aristid ];
  };
}
