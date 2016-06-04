{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gnome3, gtk, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  version = "2016-06-02";
  name = "arc-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "arc-theme";
    rev = "226098a06b646981022f0e260fd4d3ca64ff5616";
    sha256 = "1lg2iig1rws2h0p7qy1pavphyzdcchmfdlv126696jczz21d67qm";
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
