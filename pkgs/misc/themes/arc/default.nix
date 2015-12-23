{ stdenv, autoconf, automake, fetchFromGitHub, gnome3, gtk-engine-murrine, pkgconfig}:

stdenv.mkDerivation rec {
  version = "2015-12-14";
  name = "arc-gtk-theme-git-${version}";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "arc-theme";
    rev = "946cbf56077088444d6248e3e9cea76dce237e6d";
    sha256 = "0l4j4db07cill0xz7b7xh2nk8zjmh211z4j2k48a5iwd3g9a2p5b";
  };

  preferLocalBuild = true;

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

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
