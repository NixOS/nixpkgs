{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iwlwifi-3945-ucode-15.32.2.9";
  
  src = fetchurl {
    url = "http://www.intellinuxwireless.org/iwlwifi/downloads/${name}.tgz";
    sha256 = "0baf07lblwsq841zdcj9hicf11jiq06sz041qcybc6l8yyhhcqjk";
  };
  
  buildPhase = "true";

  installPhase = "ensureDir $out; chmod -x *; cp * $out";
  
  meta = {
    description = "Firmware for the Intel 3945ABG wireless card";
    homepage = http://intellinuxwireless.org/;
  };
}
