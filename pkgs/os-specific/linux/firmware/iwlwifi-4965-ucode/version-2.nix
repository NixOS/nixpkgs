{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-4965-ucode-228.61.2.24";
  
  src = fetchurl {
    url = "http://wireless.kernel.org/en/users/Drivers/iwlegacy?action=AttachFile&do=get&target=iwlwifi-4965-ucode-228.61.2.24.tgz";
    name = "iwlwifi-4965-ucode-228.61.2.24.tgz";
    sha256 = "1n5af3cci0v40w4gr0hplqr1lfvhghlbzdbf60d6185vpcny2l5m";
  };
  
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';
  
  meta = {
    description = "Firmware for the Intel 4965ABG wireless card, for Linux 2.6.27+";

    longDescription = ''
      This package provides version 2 of the Intel wireless card
      firmware, for Linux 2.6.27 and later.  It contains the
      `iwlwifi-4965-2.ucode' file, which is loaded by the `iwlagn'
      driver found in recent kernels.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
