{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gnome3, gtk, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  version = "2016-06-06";
  name = "arc-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "arc-theme";
    rev = "d24a7b5b4eb25e1a094bdf4e125332cfb8e2c8c1";
    sha256 = "07rf21xhyz3if4n5ccmzmjf9rz9w7wkvci7ccivhh6lkillfbxgi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gtk-engine-murrine ];

  preferLocalBuild = true;

  configureFlags = "--with-gnome=${gnome3.version}";

  meta = with stdenv.lib; {
    description = "A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell";
    homepage = "https://github.com/horst3180/Arc-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
