{ stdenv, fetchurl, dysnomia, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.8";
  
  src = fetchurl {
    url = "https://github.com/svanderburg/disnixos/releases/download/disnixos-0.8/disnixos-0.8.tar.gz";
    sha256 = "186blirfx89i8hdp4a0djy4q9qr9wcl0ilwr66hlil0wxqj1sr91";
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
