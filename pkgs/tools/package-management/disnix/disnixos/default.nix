{ stdenv, fetchurl, dysnomia, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.7.1";
  
  src = fetchurl {
    url = https://github.com/svanderburg/disnixos/files/2281312/disnixos-0.7.1.tar.gz;
    sha256 = "00d7mcj77lwbj67vnh81bw6k6pg2asimky4zkq32mh8dslnhpnz6";
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
