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
  version = "1.1.1+date=2023-05-05";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "01c94c77f59404924f1c46d99c4e5e0c7817281b";
    hash = "sha256-WqbobkzlJ9g5fb9S2QPi3qdpCLx3pxtNlT7qDI63Zp4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libimobiledevice
    libusb1
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

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
    maintainers = [ ];
    mainProgram = "usbmuxd";
  };
}
