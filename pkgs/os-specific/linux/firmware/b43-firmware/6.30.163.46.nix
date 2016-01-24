{ stdenv, fetchurl, b43FirmwareCutter }:

stdenv.mkDerivation rec {
  name = "b43-firmware-${version}";
  version = "6.30.163.46";

  src = fetchurl {
    url = "http://www.lwfinger.com/b43-firmware/broadcom-wl-${version}.tar.bz2";
    sha256 = "0baw6gcnrhxbb447msv34xg6rmlcj0gm3ahxwvdwfcvq4xmknz50";
  };

  buildInputs = [ b43FirmwareCutter ];

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";

  installPhase = ''
    mkdir $out
    b43-fwcutter -w $out *.wl_apsta.o
  '';

  meta = with stdenv.lib; {
    description = "Firmware for cards supported by the b43 kernel module";
    homepage = http://wireless.kernel.org/en/users/Drivers/b43;
    downloadPage = http://www.lwfinger.com/b43-firmware;
    license = licenses.unfree;
    maintainers = with maintainers; [ nckx ];
  };
}
