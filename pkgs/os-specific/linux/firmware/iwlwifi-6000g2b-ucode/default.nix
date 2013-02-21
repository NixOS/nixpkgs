{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-6000g2b-ucode-17.168.5.2";

  src = fetchurl {
    url = "http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=${name}.tgz";
    name = "${name}.tgz";
    sha256 = "5e4afdf070bfef549e50e62187f22dc2e40f5d9fe8b9a77561f8f3efb0d1d052";
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
      firmware. It contains the `iwlwifi-6000g2b-4.ucode' file.
    '';

    homepage = http://wireless.kernel.org/en/users/Drivers/iwlwifi;
  };
}
