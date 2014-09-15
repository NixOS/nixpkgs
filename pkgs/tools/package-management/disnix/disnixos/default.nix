{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2prec3310e2d8975c45e4ffacec940049fb781739b8d";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/13617499/download/3/disnixos-0.2prec3310e2d8975c45e4ffacec940049fb781739b8d.tar.gz;
    sha256 = "1kcpzzwy9jc1zz700whnp6sc77yp3wxzr935f07jy55ddkl8mdi5";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
