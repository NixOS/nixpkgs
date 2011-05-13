{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.2pre27247";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1083317/download/3/disnixos-0.2pre27247.tar.gz;
    sha256 = "0m13zkfkssqalk9z67n1d5dg0xyfjbkb8v033dc2da07d4pdh3vq";
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
