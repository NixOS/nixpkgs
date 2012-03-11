{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-5000-ucode-8.83.5.1-1";
  
  src = fetchurl {
    url = "http://www.intellinuxwireless.org/iwlwifi/downloads/${name}.tar.gz";
    sha256 = "0n4f6wsppspvvdpcab52n2piczhgfq7a4y7gazxzzlj5halchnx3";
  };
  
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';
  
  meta = {
    description = "Firmware for the Intel 5000 wireless card";

    longDescription = ''
      This package provides version 5 of the Intel wireless card
      firmware. It contains the `iwlwifi-5000-5.ucode' file.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
