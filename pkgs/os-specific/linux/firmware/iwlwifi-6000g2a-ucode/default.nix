{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iwlwifi-6000g2a-ucode-18.168.6.1";

  src = fetchurl {
    url = "http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=${name}.tgz";
    name = "${name}.tgz";
    sha256 = "a7f2615756addafbf3e6912cb0265f9650b2807d1ccdf54b620735772725bbe9";
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';

  meta = {
    homepage = http://wireless.kernel.org/en/users/Drivers/iwlwifi;
    description = "Firmware for the Intel 6000 Series Gen2 wireless card";

    longDescription = ''
      This package provides the Intel 6000 Series wireless card
      firmware. It contains the `iwlwifi-6000g2a-5.ucode' file.
    '';
  };
}
