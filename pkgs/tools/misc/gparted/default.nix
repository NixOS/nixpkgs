args: with args;
stdenv.mkDerivation {
  name = "gparted-0.4.6";

  src = fetchurl {
    url = http://downloads.sourceforge.net/project/gparted/gparted/gparted-0.4.6/gparted-0.4.6.tar.bz2;
    sha256 = "100n9ayl4sm1843w7wl8jav2crbr4k6x2jf58knlbvrr333yx9b5";
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
