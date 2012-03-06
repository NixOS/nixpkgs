{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-5000-ucode-8.24.2.12";
  
  src = fetchurl {
    url = "http://intellinuxwireless.org/iwlwifi/downloads/${name}.tgz";
    sha256 = "0h47cmpxa9cmysz0g42ga9da8qjfzqdf0w43fqx1cbnr8yg12ac1";
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
      This package provides version 1 of the Intel wireless card
      firmware, for Linux up to 2.6.26.  It contains the
      `iwlwifi-5000-1.ucode' file.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
