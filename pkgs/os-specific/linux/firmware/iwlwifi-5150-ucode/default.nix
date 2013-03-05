{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-5150-ucode-8.24.2.2";
  
  src = fetchurl {
    url = "http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=${name}.tgz";
    name = "${name}.tgz";
    sha256 = "d253e6ff6624639aded67c82df98b2bc4a66eb66400848d5614921d513540cf9";
  };
  
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';
  
  meta = {
    description = "Firmware for the Intel 5150 wireless card";

    longDescription = ''
      This package provides version 1 of the Intel wireless card
      firmware.  It contains the `iwlwifi-5150-2.ucode' file.
    '';

    homepage = http://wireless.kernel.org/en/users/Drivers/iwlwifi;
  };
}
