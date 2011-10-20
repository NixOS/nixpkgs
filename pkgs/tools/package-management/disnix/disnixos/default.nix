{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.2pre29928";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1464065/download/3/disnixos-0.2pre29928.tar.gz;
    sha256 = "0l7kszbpi8lzq95khi45fbq71l5csf8kamds4va6bxsyfwxrx6sm";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
