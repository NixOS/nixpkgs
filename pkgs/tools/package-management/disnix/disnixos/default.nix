{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2pre7a84a34a2e36dd3fbd399d3b9f27168a9d2a0add";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/20213021/download/3/disnixos-0.2pre7a84a34a2e36dd3fbd399d3b9f27168a9d2a0add.tar.gz;
    sha256 = "1dc9q8i9vhw0851w9b7giv570rly172mmqfr6khr2r88npc642xc";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
