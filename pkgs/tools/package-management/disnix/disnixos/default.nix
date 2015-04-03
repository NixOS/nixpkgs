{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/20419306/download/3/disnixos-0.2.tar.gz;
    sha256 = "1xysklly0gvh0np0h3f30sfs5lx6qnwj59l8caynwn46qy596gnx";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
