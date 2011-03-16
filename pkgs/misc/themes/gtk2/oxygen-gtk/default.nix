{ stdenv, fetchurl, 
  cmake, glib, gtk, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  name = "oxygen-gtk-${version}";  

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk/${version}/src/${name}.tar.bz2";
    sha256 = "0ki8qllr5ai48bl2pz8rxzf5cax08ckhgrn0nlf815ba83jfar32";
  };
  
  buildInputs = [ cmake glib gtk pkgconfig ];
  
  meta = with stdenv.lib; {
    description = "Port of the default KDE widget theme (Oxygen), to gtk";
    homepage = https://projects.kde.org/projects/playground/artwork/oxygen-gtk;
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
  };
}
