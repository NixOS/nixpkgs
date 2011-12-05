{ stdenv, fetchurl, hotplugSupport ? true, libusb ? null
, gt68xxFirmware ? null }:
let
  firmware = gt68xxFirmware {inherit fetchurl;};
in
assert hotplugSupport -> stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "sane-backends-1.0.22.git201111204";
  
  src = fetchurl {
    url = http://www.sane-project.org/snapshots/sane-backends-git20111204.tar.gz;
    sha256 = "00b3fi8zjrq3in0wndz1xcz228mgfhwhh2knmyjsikr88hal0m47";
  };
  
  udevSupport = hotplugSupport;

  buildInputs = if libusb != null then [libusb] else [];

  postInstall = ''
    if test "$udevSupport" = "1"; then
      ensureDir $out/etc/udev/rules.d/
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
