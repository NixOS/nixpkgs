{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.2pre29885";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1461383/download/3/disnixos-0.2pre29885.tar.gz;
    sha256 = "1lyxpadykk7nbb7gad12mbcsz29c6fqihhv3k3vkh32fimbq7bma";
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
