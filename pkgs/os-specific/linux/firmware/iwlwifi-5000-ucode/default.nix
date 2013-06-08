{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-5000-ucode-8.83.5.1-1";
  
  src = fetchurl {
    url = "http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-5000-ucode-8.83.5.1-1.tgz";
    name = "iwlwifi-5000-ucode-8.83.5.1-1.tgz";
    sha256 = "0pkzr4gflp3j0jm4rw66jypk3xn4bvpgdsnxjqwanyd64aj6naxg";
  };
  
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    chmod -x *
    cp * "$out"
  '';
  
  meta = {
    description = "Firmware for the Intel 5000 wireless card";

    longDescription = ''
      This package provides version 5 of the Intel wireless card
      firmware. It contains the `iwlwifi-5000-5.ucode' file.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}
