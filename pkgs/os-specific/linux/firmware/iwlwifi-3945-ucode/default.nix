{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "iwlwifi-3945-ucode-15.28.1.8";
  
  src = fetchurl {
    url = http://www.intellinuxwireless.org/iwlwifi/downloads/iwlwifi-3945-ucode-15.28.1.8.tgz;
    sha256 = "0pwilsk8m9f5ihlp3wlam485a52lkbj2di5990bnz2m6ina9j8v2";
  };
  
  buildPhase = "true";

  installPhase = "ensureDir $out; chmod -x *; cp * $out";
  
  meta = {
    description = "Firmware for the Intel 3945ABG wireless card";
    homepage = http://intellinuxwireless.org/;
  };
}
