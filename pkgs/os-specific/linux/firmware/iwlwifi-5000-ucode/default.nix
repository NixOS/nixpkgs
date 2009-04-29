{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-5000-ucode-5.4.A.11";
  
  src = fetchurl {
    url = "http://intellinuxwireless.org/iwlwifi/downloads/${name}.tar.gz";
    sha256 = "0mbxfl2phjv5wa6ngml4yg6wn8yjva843i91532fr75rd6z78fxl";
  };
  
  buildPhase = "true";

  installPhase = ''
    ensureDir "$out"
    chmod -x *
    cp * "$out"
  '';
  
  meta = {
    description = "Firmware for the Intel 5000 wireless card";

    longDescription = ''
      This package provides version 1 of the Intel wireless card
      firmware, for Linux up to 2.6.26.  It contains the
      `iwlwifi-5000-1.ucode' file.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
