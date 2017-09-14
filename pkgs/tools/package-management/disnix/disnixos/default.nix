{ stdenv, fetchurl, dysnomia, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.6.1";
  
  src = fetchurl {
    url = https://github.com/svanderburg/disnixos/releases/download/disnixos-0.6.1/disnixos-0.6.1.tar.gz;
    sha256 = "0pqv8n9942vjwmb32m1af29fi0vjlsbwkj2c7h1xs28z6wahr7wa";
  };
  
  buildInputs = [ socat pkgconfig dysnomia disnix getopt ];
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
