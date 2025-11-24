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
    sha256 = "0baw6gcnrhxbb447msv34xg6rmlcj0gm3ahxwvdwfcvq4xmknz50";
  };

  nativeBuildInputs = [ b43FirmwareCutter ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/lib/firmware
    b43-fwcutter -w $out/lib/firmware *.wl_apsta.o
  '';

  meta = with lib; {
    description = "Firmware for cards supported by the b43 kernel module";
    homepage = "https://wireless.wiki.kernel.org/en/users/drivers/b43";
    downloadPage = "http://www.lwfinger.com/b43-firmware";
    license = licenses.unfree;
  };
}
