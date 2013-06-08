{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-4965-ucode-228.57.1.21";
  
  src = fetchurl {
    url = "wireless.kernel.org/en/users/Drivers/iwlegacy?action=AttachFile&do=get&target=${name}.tgz";
    name = "${name}.tgz";
    sha256 = "1rry0kpzszxk60h5gb94advzi009010xb332iyvfpaiwbj6aiyas";
  };
  
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"

    # The driver expects the `-1' in the file name.
    cd "$out"
    ln -s iwlwifi-4965.ucode iwlwifi-4965-1.ucode
  '';
  
  meta = {
    description = "Firmware for the Intel 4965ABG wireless card";

    longDescription = ''
      This package provides version 2 of the Intel wireless card
      firmware, for Linux up to 2.6.26.  It contains the
      `iwlwifi-4965-1.ucode' file, which is loaded by the `iw4965'
      driver found in recent kernels.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
