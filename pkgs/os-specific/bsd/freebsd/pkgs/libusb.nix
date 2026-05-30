{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libusb";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  postInstall = ''
    mv $out/data/pkgconfig $out/lib/pkgconfig
  '';

  meta.platforms = lib.platforms.freebsd;
}
