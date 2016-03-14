{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.4";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/31143419/download/3/disnixos-0.4.tar.gz;
    sha256 = "0ff2k15j34b947b8pnw5xhsv9blk9kq350pcp3p3p2qclgf9ahfh";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
