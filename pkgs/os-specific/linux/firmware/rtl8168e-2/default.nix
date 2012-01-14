{ stdenv, fetchurl }:

let
  src = fetchurl {
    url = "http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=rtl_nic/rtl8168e-2.fw";
    sha256 = "11lkwc6r6f5pi8clxajp43j6dzapydgxaxaschribpvhn8lrjj0a";
    name = "rtl8168e-2.fw";
  };
in
stdenv.mkDerivation {
  name = "rtl8168e-2-firmware-2012.01.10";

  unpackPhase = "true";

  buildPhase = "true";

  installPhase = "install -v -D ${src} $out/rtl_nic/${src.name}";

  meta = {
    description = "Firmware for the Realtek Gigabit Ethernet controllers";
  };
}
