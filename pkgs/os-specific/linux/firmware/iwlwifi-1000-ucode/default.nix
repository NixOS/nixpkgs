{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-1000-ucode-128.50.3.1";
  
  src = fetchurl {
    url = "http://intellinuxwireless.org/iwlwifi/downloads/${name}.tgz";
    sha256 = "7e81ddad18acec19364c9df22496e8afae99a2e1490b2b178e420b52d443728d";
  };
  
  buildPhase = "true";

  installPhase = ''
    ensureDir "$out"
    chmod -x *
    cp * "$out"
  '';
  
  meta = {
    description = "Firmware for the Intel 1000 wireless card";

    longDescription = ''
      This package provides version 3 of the Intel wireless card
      firmware, for Linux up to 2.6.26.  It contains the
      `iwlwifi-1000-3.ucode' file, which is loaded by the `iwlagn'
      driver found in recent kernels.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
