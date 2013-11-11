{ stdenv, fetchurl, disnix, socat, pkgconfig }:

stdenv.mkDerivation {
  name = "disnixos-0.2prebb320d396f93d7062c28d6a54105d8e8196b9d99";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/6769017/download/3/disnixos-0.2prebb320d396f93d7062c28d6a54105d8e8196b9d99.tar.gz;
    sha256 = "0jw05qjn0fbf4xb2g8a8i0padmsw17ayr4acw7z784bljrm1z055";
  };
  
  buildInputs = [ socat pkgconfig disnix ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
