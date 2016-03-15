{stdenv, fetchurl }:

let

  rev = "b7bbd3d1683e9f3bb11ef86b952adee71e83862f";

in stdenv.mkDerivation {
  name = "raspberrypi-firmware-${rev}";

  src = fetchurl {
    url = "https://github.com/raspberrypi/firmware/archive/${rev}.tar.gz";
    sha256 = "16wpwa1y3imd3la477b3rfbfypssvlh0zjdag3hgkm33aysizijp";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
    cp -R hardfp/opt/vc/* $out
    cp opt/vc/LICENCE $out/share/raspberrypi

    for f in $out/bin/*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f"
      patchelf --set-rpath "$out/lib" "$f"
    done
  '';

  meta = {
    description = "Firmware for the Raspberry Pi board";
    homepage = https://github.com/raspberrypi;
    license = stdenv.lib.licenses.unfree;
  };
}
