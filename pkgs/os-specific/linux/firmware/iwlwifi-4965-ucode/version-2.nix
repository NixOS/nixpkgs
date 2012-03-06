{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-4965-ucode-228.57.2.21";
  
  src = fetchurl {
    url = "http://intellinuxwireless.org/iwlwifi/downloads/" + name + ".tgz";
    sha256 = "1ss8r9l8j28n4zplpcwf81n74yy7p4q9dldnblmh4g0h9nyr8nf0";
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
