{
  lib,
  stdenvNoCC,
  fetchurl,
  b43FirmwareCutter,
}:

stdenvNoCC.mkDerivation rec {
  pname = "b43-firmware";
  version = "6.30.163.46";

  src = fetchurl {
    url = "http://www.lwfinger.com/b43-firmware/broadcom-wl-${version}.tar.bz2";
    hash = "sha256-oHw7ayd4M8fb5h2qUR+QjNZsXidj63oIWavDbNkzXC0=";
  };

  nativeBuildInputs = [ b43FirmwareCutter ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/lib/firmware
    b43-fwcutter -w $out/lib/firmware *.wl_apsta.o
  '';

  meta = {
    description = "Firmware for cards supported by the b43 kernel module";
    homepage = "https://wireless.wiki.kernel.org/en/users/drivers/b43";
    downloadPage = "http://www.lwfinger.com/b43-firmware";
    license = lib.licenses.unfree;
  };
}
