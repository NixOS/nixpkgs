{stdenv, linuxFirmware}:
let
  src  = linuxFirmware;
  dir  = "rtlwifi";
  file = "rtl8192cfw.bin";
  meta = {
    description = "Firmware for the Realtek RTL8192c wireless cards";
    homepage = "http://www.realtek.com";
    license = "non-free";
  };  
in stdenv.mkDerivation {
  name = "rtl8192c-fw";
  inherit src meta dir file;

  phases = [ "installPhase" ];

  installPhase = "ensureDir $out/$dir && cp $src/$dir/$file $out/$dir/$file";
}
