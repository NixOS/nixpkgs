{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2pre7bbac66b0ed3b637c6ebcfdd8f12055cc330093c";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/20062333/download/3/disnixos-0.2pre7bbac66b0ed3b637c6ebcfdd8f12055cc330093c.tar.gz;
    sha256 = "0d5ql8n93l8xa949cwk7v55lpfcp8j0x8wigqwfh6gim5f21niyb";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
