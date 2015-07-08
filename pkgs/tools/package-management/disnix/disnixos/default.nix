{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.3";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/23484787/download/3/disnixos-0.3.tar.gz;
    sha256 = "08v9vbg3727mv4iyzwfnf5x3la2xjj1agbbzm8aaa09q7alqasvw";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
