{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libusb1, libimobiledevice }:

stdenv.mkDerivation rec {
  pname = "usbmuxd";
  version = "unstable-2021-05-08";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "5e484e18f1383b5a0bd6c353ab1d668b03e4ffab";
    sha256 = "sha256-hhbfRmLEhVVuJNnw65PakPnvjSCrN3oSMK6D7Zwnw60=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  propagatedBuildInputs = [ libimobiledevice libusb1 ];

  preConfigure = ''
    configureFlags="$configureFlags --with-udevrulesdir=$out/lib/udev/rules.d"
    configureFlags="$configureFlags --with-systemdsystemunitdir=$out/lib/systemd/system"
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/usbmuxd";
    description = "A socket daemon to multiplex connections from and to iOS devices";
    longDescription = ''
      usbmuxd stands for "USB multiplexing daemon". This daemon is in charge of
      multiplexing connections over USB to an iOS device. To users, it means
      you can sync your music, contacts, photos, etc. over USB. To developers, it
      means you can connect to any listening localhost socket on the device. usbmuxd
      is not used for tethering data transfer which uses a dedicated USB interface as
      a virtual network device. Multiple connections to different TCP ports can happen
      in parallel. The higher-level layers are handled by libimobiledevice.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ infinisil ];
  };
}
