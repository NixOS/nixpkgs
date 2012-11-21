{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iwlwifi-6000g2a-ucode-18.168.6.1";

  src = fetchurl {
    url = "http://intellinuxwireless.org/iwlwifi/downloads/${name}.tgz";
    sha256 = "a7f2615756addafbf3e6912cb0265f9650b2807d1ccdf54b620735772725bbe9";
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';

  meta = {
    homepage = "http://intellinuxwireless.org/";
    description = "Firmware for the Intel 6000 Series Gen2 wireless card";

    longDescription = ''
      This package provides the Intel 6000 Series wireless card
      firmware. It contains the `iwlwifi-6000g2a-5.ucode' file.
    '';
  };
}
