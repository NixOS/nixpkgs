{ stdenv, fetchurl, fetchgit, hotplugSupport ? true, libusb ? null, gt68xxFirmware ? null }:
let
  firmware = gt68xxFirmware { inherit fetchurl; };
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.22.git20121123";

  src = fetchurl {
    url = "http://www.sane-project.org/snapshots/sane-backends-git20121123.tar.gz";
    sha256 = "d13a8c9e85af52f7be2e45c70cb93a76ec04b76e7fc983809e7d70389b6e7ae5";
  };

  udevSupport = hotplugSupport;

  buildInputs = if libusb != null then [libusb] else [];

  postInstall = ''
    if test "$udevSupport" = "1"; then
      mkdir -p $out/etc/udev/rules.d/
      ./tools/sane-desc -m udev > $out/etc/udev/rules.d/60-libsane.rules || \
      cp tools/udev/libsane.rules $out/etc/udev/rules.d/60-libsane.rules
    fi
  '';

  preInstall =
    if gt68xxFirmware != null then
      "mkdir -p \${out}/share/sane/gt68xx ; ln -s " + firmware.fw +
      " \${out}/share/sane/gt68xx/" + firmware.name
    else "";
}
