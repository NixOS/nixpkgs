{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2prec3310e2d8975c45e4ffacec940049fb781739b8d";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/14721464/download/3/disnixos-0.2prec3310e2d8975c45e4ffacec940049fb781739b8d.tar.gz;
    sha256 = "0wd0bhzwipn62lb90fk2s9s52aq60ndriyw7ymah6x3xm40d2cl9";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
