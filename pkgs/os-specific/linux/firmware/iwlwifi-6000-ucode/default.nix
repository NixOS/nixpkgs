{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-6000-ucode-9.221.4.1";

  src = fetchurl {
    url = "http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=${name}.tgz";
    name = "${name}.tgz";
    sha256 = "7f04623231663dc4ee63df32fd890bfa9514dce1fab9dc7a25fda90350da836b";
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';

  meta = {
    description = "Firmware for the Intel 6000 Series wireless card";

    longDescription = ''
      This package provides the Intel 6000 Series wireless card
      firmware. It contains the `iwlwifi-6000-4.ucode' file.
    '';

    homepage = http://wireless.kernel.org/en/users/Drivers/iwlwifi;
  };
}
