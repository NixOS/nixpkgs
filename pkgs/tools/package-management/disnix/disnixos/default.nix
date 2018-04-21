{ stdenv, fetchurl, dysnomia, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.7";
  
  src = fetchurl {
    url = https://github.com/svanderburg/disnixos/files/1756702/disnixos-0.7.tar.gz;
    sha256 = "1qf9h3q1r27vg1ry55lj01knq6i0c213f6vlg7wj958mml7fk37b";
  };
  
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ socat dysnomia disnix getopt ];
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
