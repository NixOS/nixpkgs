{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-6000g2a-ucode-17.168.5.3";

  src = fetchurl {
    url = "http://intellinuxwireless.org/iwlwifi/downloads/${name}.tgz";
    sha256 = "febbbc0851db17296d35e5ca1d9266c1a14e9a9ae6ce41a36578c44971ae79f9";
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';

  meta = {
    description = "Firmware for the Intel 6000 Series Gen2 wireless card";

    longDescription = ''
      This package provides the Intel 6000 Series wireless card
      firmware. It contains the `iwlwifi-6000g2a-5.ucode' file.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
