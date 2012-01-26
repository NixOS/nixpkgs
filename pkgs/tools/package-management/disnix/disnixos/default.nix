{ stdenv, fetchurl, disnix, socat, pkgconfig }:

stdenv.mkDerivation {
  name = "disnixos-0.2pre31830";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/1934498/download/3/disnixos-0.2pre31830.tar.gz;
    sha256 = "02f2b4lk1gr24rqs56az82b3h3mnqrk1m48bcj21x109g4vrlpmm";
  };
  
  buildInputs = [ socat pkgconfig disnix ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
