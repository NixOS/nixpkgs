{ stdenv, fetchurl, dysnomia, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.6";
  
  src = fetchurl {
    url = https://github.com/svanderburg/disnixos/files/842874/disnixos-0.6.tar.gz;
    sha256 = "0pgqsk8qndn614z02jq3vbxzpx6fmgsm6pr1g0iqz55pzwamw9j7";
  };
  
  buildInputs = [ socat pkgconfig dysnomia disnix getopt ];
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
