{ stdenv, autoconf, automake, fetchFromGitHub, gnome3, gtk, gtk-engine-murrine, pkgconfig}:

stdenv.mkDerivation rec {
  version = "2015-10-21";
  name = "arc-gtk-theme-git-${version}";
  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "arc-theme";
    sha256 = "09s452ysg5ys5i3ahb2dgdmr9j64b92hy9rgfvbgw6r5kdrnb60s";
    rev = "f4c71247cf9470037d052ae4a12b86073d0001ff";
  };

  preferLocalBuild = true;

  buildInputs = [ autoconf automake gtk-engine-murrine pkgconfig ];

  configureScript = "./autogen.sh";
  configureFlags = "--with-gnome=${gnome3.version}";

  meta = with stdenv.lib; {
    description = "A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell";
    homepage = "https://github.com/horst3180/Arc-theme";
    license = licenses.gpl3;
    maintainers = [ maintainers.simonvandel ];
    platforms = platforms.linux;
  };
}
