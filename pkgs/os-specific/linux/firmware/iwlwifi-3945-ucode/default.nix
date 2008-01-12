{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "iwlwifi-3945-ucode-2.14.1.5";
  
  src = fetchurl {
    url = http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-3945-ucode-2.14.1.5.tgz;
    sha256 = "06gy21qkd4kj6pf3nsz5z3xkgmcafzrm1krywd8lbb8i56i3jkra";
  };
  
  buildPhase = "true";

  installPhase = "ensureDir $out; chmod -x *; cp * $out";
  
  meta = {
    description = "Firmware for the Intel 3945ABG wireless card";
    homepage = http://intellinuxwireless.org/;
  };
}
