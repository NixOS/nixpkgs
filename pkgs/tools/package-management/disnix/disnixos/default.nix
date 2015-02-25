{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2pred5b649fa44bd3a1003d6466431ccbd07e79fe50f";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/19868070/download/3/disnixos-0.2pred5b649fa44bd3a1003d6466431ccbd07e79fe50f.tar.gz;
    sha256 = "0vkj5y8v734m3dmkg71d2jdk7bwgahn44yi62843a0mzjijngdzj";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
