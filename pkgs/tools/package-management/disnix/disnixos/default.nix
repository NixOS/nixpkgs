{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.2pre30424";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1927459/download/3/disnixos-0.2pre30424.tar.gz;
    sha256 = "1n7lxmgrwqxvf227zk91kfnc3fgzri6jviyvcalwy951n891684k";
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
