{ stdenv, fetchurl, disnix, socat, pkgconfig }:

stdenv.mkDerivation {
  name = "disnixos-0.2pre33586";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/2368187/download/3/disnixos-0.2pre33586.tar.gz;
    sha256 = "110vn4390447dws343py8ss6s8jizx8yg7yl38i64nlqh0bcn4ny";
  };
  
  buildInputs = [ socat pkgconfig disnix ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
