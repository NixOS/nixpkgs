{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.2pre27272";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1112308/download/3/disnixos-0.2pre27272.tar.gz;
    sha256 = "0ij06bz24ig9g6h3pig7kwvndj46vnabpyfb173vy2ll1mx0vqnp";
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
