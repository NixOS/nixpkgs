{ stdenv, fetchurl, 
  cmake, glib, gtk, pkgconfig }:

stdenv.mkDerivation rec {
  name = "oxygen-gtk";
  version = "1.0.1";
  
  src = fetchurl {
    url = "mirror://kde/stable/${name}/${version}/src/${name}-${version}.tar.bz2";
    sha256 = "0ki8qllr5ai48bl2pz8rxzf5cax08ckhgrn0nlf815ba83jfar32";
  };
  
  buildInputs = [ cmake glib gtk pkgconfig ];
  
  meta = {
    description = "Port of the default KDE widget theme (Oxygen), to gtk";
    homepage = https://projects.kde.org/projects/playground/artwork/oxygen-gtk;
    licence = "LGPLv2";
  };
}
