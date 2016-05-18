{ stdenv, autoconf, automake, fetchFromGitHub, gnome3, gtk, gtk-engine-murrine, pkgconfig}:

stdenv.mkDerivation rec {
  version = "2016-05-14";
  name = "arc-gtk-theme-git-${version}";
  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "arc-theme";
    rev = "fb3fe2fc0b280e9d8ca4b5fc5ca23e5b00fcac27";
    sha256 = "1q844i7bkf75jv9fvf15n47vwvzzbkvhv5ssxl98q8x66dgjwx35";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ autoconf automake pkgconfig ];

  buildInputs = [ gtk-engine-murrine ];

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
