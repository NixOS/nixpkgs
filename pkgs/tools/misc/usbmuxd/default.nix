{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libimobiledevice
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "usbmuxd";
  version = "1.1.1+date=2022-04-04";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "2839789bdb581ede7c331b9b4e07e0d5a89d7d18";
    hash = "sha256-wYW6hI0Ti9gKtk/wxIbdY5KaPMs/p+Ve9ceeRqXihQI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libimobiledevice
    libusb1
  ];

  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinisil ];
  };
}
