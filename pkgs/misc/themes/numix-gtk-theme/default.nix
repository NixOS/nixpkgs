{ stdenv, fetchFromGitHub, sass, glib, libxml2, gdk_pixbuf
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  version = "2016-05-19";
  name = "numix-gtk-theme-${version}";

  src = fetchFromGitHub {
    repo = "numix-gtk-theme";
    owner = "numixproject";
    rev = "266945047ad8c148d36d0d1f00b39730b84482a9";
    sha256 = "108qjqwn9shqjkbadyw79y1wbq5ndv30x7xw5wjmbcss5jikr3v1";
  };

  nativeBuildInputs = [ sass glib libxml2 gdk_pixbuf ];

  buildInputs = [ gtk-engine-murrine ];

  installPhase = ''
    make install DESTDIR="$out"
  '';

  meta = {
    description = "Modern flat theme with a combination of light and dark elements (GNOME, Unity, Xfce and Openbox)";
    homepage = https://numixproject.org;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
