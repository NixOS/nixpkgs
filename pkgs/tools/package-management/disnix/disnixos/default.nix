{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.4.1";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/33130082/download/3/disnixos-0.4.1.tar.gz;
    sha256 = "1r6b73qhz64z7xms6hkmm495yz0114pqa61b2qzlmzmlywhhy15b";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
