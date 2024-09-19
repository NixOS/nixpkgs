{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libimobiledevice,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usbmuxd";
  version = "1.1.1-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "usbmuxd";
    rev = "0b1b233b57d581515978a09e5a4394bfa4ee4962";
    hash = "sha256-KXsOYE5PEPO897HWXJDpwsIOj/VwTthil6HDJXOJ8DM=";
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
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/usbmuxd";
    description = "Socket daemon to multiplex connections from and to iOS devices";
    longDescription = ''
      usbmuxd stands for "USB multiplexing daemon". This daemon is in charge of
      multiplexing connections over USB to an iOS device. To users, it means
      you can sync your music, contacts, photos, etc. over USB. To developers, it
      means you can connect to any listening localhost socket on the device. usbmuxd
      is not used for tethering data transfer which uses a dedicated USB interface as
      a virtual network device. Multiple connections to different TCP ports can happen
      in parallel. The higher-level layers are handled by libimobiledevice.
    '';
    license = with licenses; [
      gpl2
      gpl3
    ];
    platforms = platforms.unix;
    maintainers = [ frontear ];
    mainProgram = "usbmuxd";
  };
})
