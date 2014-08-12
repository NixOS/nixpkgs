{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2prebb320d396f93d7062c28d6a54105d8e8196b9d99";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/9877039/download/3/disnixos-0.2preb10c56eeb1be3046645eea90c779e2d64045581f.tar.gz;
    sha256 = "1pkpf6vp9q3jjp212lghbs1km8iqh4rm9xa5jm0dqb5ya25f0jf2";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
