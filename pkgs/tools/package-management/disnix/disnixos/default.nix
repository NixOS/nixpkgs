{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.1";
  src = fetchurl {
    url = http://hydra.nixos.org/build/910925/download/3/disnixos-0.1.tar.gz;
    sha256 = "0gd0jnc8n50g55lv4ha9nim9s2gv7mi4qdz4j3rnaws86sfgh8x2";
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
