{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-2030-ucode-18.168.6.1";

  src = fetchurl {
    url = "http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=${name}.tgz";
    name = "${name}.tgz";
    sha256 = "0b69jpb46fk63ybyyb8lbh99j1d29ayp8fl98l18iqy3q7mx4ry8";
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';

  meta = {
    description = "Firmware for the Intel 2030 Series wireless card";

    longDescription = ''
      This package provides the Intel 2030 Series wireless card
      firmware. It contains the `iwlwifi-2030-6.ucode' file.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
