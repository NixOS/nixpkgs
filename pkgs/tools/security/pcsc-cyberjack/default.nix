{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libusb1, pcsclite }:

let
  version = "3.99.5";
<<<<<<< HEAD
  suffix = "SP15";
  tarBall = "${version}final.${suffix}";

in
stdenv.mkDerivation rec {
=======
  suffix = "SP13";
  tarBall = "${version}final.${suffix}";

in stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "pcsc-cyberjack";
  inherit version;

  src = fetchurl {
    url =
<<<<<<< HEAD
      "https://support.reiner-sct.de/downloads/LINUX/V${version}_${suffix}/${pname}_${tarBall}.tar.bz2";
    sha256 = "sha256-rLfCgyRQcYdWcTdnxLPvUAgy1lLtUbNRELkQsR69Rno=";
=======
      "http://support.reiner-sct.de/downloads/LINUX/V${version}_${suffix}/${pname}_${tarBall}.tar.gz";
    sha256 = "1lx4bfz4riz7j77sl65akyxzww0ygm63w0c1b75knr1pijlv8d3b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "tools" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libusb1 pcsclite ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=narrowing";

  configureFlags = [
    "--with-usbdropdir=${placeholder "out"}/pcsc/drivers"
    "--bindir=${placeholder "tools"}/bin"
  ];

  postInstall = "make -C tools/cjflash install";

  meta = with lib; {
    description = "REINER SCT cyberJack USB chipcard reader user space driver";
    homepage = "https://www.reiner-sct.com/";
    license = licenses.gpl2Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ aszlig flokli ];
=======
    maintainers = with maintainers; [ aszlig ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
