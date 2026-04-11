{
  lib,
  mkDerivation,
  libusb,
}:
mkDerivation {
  path = "usr.sbin/usbconfig";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  buildInputs = [
    libusb
  ];

  meta.mainProgram = "usbconfig";
  meta.platforms = lib.platforms.freebsd;
}
