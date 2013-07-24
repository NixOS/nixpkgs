{ stdenv, fetchurl, disnix, socat, pkgconfig }:

stdenv.mkDerivation {
  name = "disnixos-0.2pre827a5b52b8a68b7c16a2d92898e6281c54e7b1ff";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/5430738/download/3/disnixos-0.2pre827a5b52b8a68b7c16a2d92898e6281c54e7b1ff.tar.gz;
    sha256 = "1alyzypli32whd371w9wfxcnq6by9zng88nysd3gy8nrvns8di7x";
  };
  
  buildInputs = [ socat pkgconfig disnix ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
