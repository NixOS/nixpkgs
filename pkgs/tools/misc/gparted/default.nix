args: with args;
stdenv.mkDerivation {
  name = "gparted-0.5.1";

  src = fetchurl {
    url = mirror://sourceforge/gparted/gparted-0.5.1/gparted-0.5.1.tar.bz2;
    sha256 = "1mqi1hxv6bahp771bqld0a6wx7khdxvz353n47q1wmqykmn4wbp0";
  };

  configureFlags = "--disable-doc";

  buildInputs = [parted gtk glib intltool gettext libuuid pkgconfig
    gtkmm gnomedocutils libxml2];

  meta = { 
      description = "gui partition tool";
      homepage = http://gparted.sourceforge.net;
      license = "GPLv2";
  };
}
