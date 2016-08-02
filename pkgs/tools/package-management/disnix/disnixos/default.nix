{ stdenv, fetchurl, dysnomia, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.5";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/36899006/download/3/disnixos-0.5.tar.gz;
    sha256 = "0pl3j8kwcz90as5cs0yipfbg555lw3z6xsylk6g2ili878mni1aq";
  };
  
  buildInputs = [ socat pkgconfig dysnomia disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
