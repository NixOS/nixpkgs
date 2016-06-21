{
  stdenv,
  fetchgit,
  autoreconfHook,
  pkgconfig,
  bundler,
  sass,
  glib,
  libxml2,
  inkscape,
  gtk,
  gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.21.3.1";

  meta = with stdenv.lib; {
    description = "An adaptive GTK+ theme based on Material Design";
    homepage = "https://github.com/tista500/Adapta";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.SShrike ];
  };

  src = fetchgit {
    url = "https://github.com/tista500/Adapta";
    rev = "refs/tags/${version}";
    sha256 = "11xbwg82x9qzk5a2p5fi9mhi3ij220ij6v45id6rzzc8bs51jach";
  };

  preferLocalBuild = true;
  buildInputs = [ gtk gtk-engine-murrine ];
  nativeBuildInputs = [ autoreconfHook bundler sass glib libxml2 inkscape ];

  configureFlags = "--enable-chrome --disable-unity";
}
