{ stdenv, fetchurl, hotplugSupport ? true, libusb ? null
, gt68xxFirmware ? null }:
let
  firmware = gt68xxFirmware {inherit fetchurl;};
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.22";
  
  src = fetchurl {
    url = http://alioth.debian.org/frs/download.php/3503/sane-backends-1.0.22.tar.gz;
    sha256 = "0m0cz4ljw9asqvpryl6gx1ndwf7ll2qinlvql9whnzs901la314z";
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
