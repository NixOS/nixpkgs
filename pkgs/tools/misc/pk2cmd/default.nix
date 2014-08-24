{stdenv, fetchurl, libusb, makeWrapper}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "pk2cmd-1.20";
  src = fetchurl {
    url = http://ww1.microchip.com/downloads/en/DeviceDoc/pk2cmdv1.20LinuxMacSource.tar.gz;
    sha256 = "1yjpi2qshnqfpan4w3ggakkr3znfrx5cxkny92ka7v9na3g2fc4h";
  };

  makeFlags = [ "LIBUSB=${libusb}" "linux" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/pk2
    cp pk2cmd $out/bin
    cp PK2DeviceFile.dat $out/share/pk2
    wrapProgram $out/bin/pk2cmd --prefix PATH : $out/share/pk2
  '';

  buildInputs = [ libusb makeWrapper ];

  meta = {
    homepage = http://www.microchip.com/pickit2;
    license = "nonfree"; #MicroChip-PK2
    description = "Microchip PIC programming software for the PICKit2 programmer";
  };
}
