{ stdenv, fetchurl, hotplugSupport ? true, libusb ? null
, gt68xxFirmware ? null }:
let
  firmware = gt68xxFirmware {inherit fetchurl;};
in
assert hotplugSupport -> (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux");

stdenv.mkDerivation {
  name = "sane-backends-1.0.21";
  
  src = fetchurl {
    url = ftp://ftp.sane-project.org/pub/sane/sane-backends-1.0.21/sane-backends-1.0.21.tar.gz;
    sha256 = "12wl4a86hxwlrx46lm5z6lw4id3j8wi82yv3khxcz5sqjai2ykp4";
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
