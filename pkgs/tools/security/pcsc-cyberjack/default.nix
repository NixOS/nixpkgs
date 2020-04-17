{ stdenv, fetchurl, autoreconfHook, pkgconfig, libusb1, pcsclite }:

stdenv.mkDerivation rec {
  pname = "pcsc-cyberjack";
  version = "3.99.5_SP13";

  src = with stdenv.lib; let
    splittedVer = splitString "_" version;
    mainVer = if length splittedVer >= 1 then head splittedVer else version;
    spVer = optionalString (length splittedVer >= 1) ("." + last splittedVer);
    tarballVersion = "${mainVer}final${spVer}";
  in fetchurl {
    url = "http://support.reiner-sct.de/downloads/LINUX/V${version}"
        + "/pcsc-cyberjack_${tarballVersion}.tar.gz";
    sha256 = "1lx4bfz4riz7j77sl65akyxzww0ygm63w0c1b75knr1pijlv8d3b";
  };

  outputs = [ "out" "tools" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libusb1 pcsclite ];

  configureFlags = [
    "--with-usbdropdir=${placeholder "out"}/pcsc/drivers"
    "--bindir=${placeholder "tools"}/bin"
  ];

  postInstall = "make -C tools/cjflash install";

  meta = with stdenv.lib; {
    description = "REINER SCT cyberJack USB chipcard reader user space driver";
    homepage = "https://www.reiner-sct.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aszlig ];
  };
}
