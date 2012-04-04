{ stdenv, fetchurl, disnix, socat, pkgconfig }:

stdenv.mkDerivation {
  name = "disnixos-0.2pre33556";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/2363206/download/3/disnixos-0.2pre33556.tar.gz;
    sha256 = "0fq96cqd0hfa6cwz7phq7ccm935hlcwmjd59vfsp6bwp0wyjzpzl";
  };
  
  buildInputs = [ socat pkgconfig disnix ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
