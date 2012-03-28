{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iwlwifi-3945-ucode-15.32.2.9";
  
  src = fetchurl {
    url = http://pkgs.fedoraproject.org/repo/pkgs/iwl3945-firmware/iwlwifi-3945-ucode-15.32.2.9.tgz/d99a75ab1305d1532a09471b2f9a547a/iwlwifi-3945-ucode-15.32.2.9.tgz;
    sha256 = "0baf07lblwsq841zdcj9hicf11jiq06sz041qcybc6l8yyhhcqjk";
  };
  
  buildPhase = "true";

  installPhase = "mkdir -p $out; chmod -x *; cp * $out";
  
  meta = {
    description = "Firmware for the Intel 3945ABG wireless card";
    homepage = http://intellinuxwireless.org/;
  };
}
