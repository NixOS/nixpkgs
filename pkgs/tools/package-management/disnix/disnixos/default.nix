{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.2pre27672";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1153468/download/3/disnixos-0.2pre27672.tar.gz;
    sha256 = "0z74p9fnvchvl78brj2p3r9h0wwvpl86zk0ynzqcf8ww0h71ws08";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to NixOS";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
