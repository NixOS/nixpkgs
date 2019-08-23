{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, usbmuxd, libzip, libimobiledevice }:

stdenv.mkDerivation rec {
  pname = "ideviceinstaller";
  version = "2018-10-01";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "f14def7cd9303a0fe622732fae9830ae702fdd7c";
    sha256 = "1biwhbldvgdhn8ygp7w79ca0rivzdjpykr76pyhy7r2fa56mrwq8";
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
    maintainers = with maintainers; [ aristid infinisil ];
  };
}
