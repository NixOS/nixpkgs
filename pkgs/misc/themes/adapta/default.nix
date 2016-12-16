{ stdenv, fetchFromGitHub, autoreconfHook, parallel, sassc, inkscape, libxml2, glib, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.89.1.66";

  meta = with stdenv.lib; {
    description = "An adaptive GTK+ theme based on Material Design";
    homepage = "https://github.com/tista500/Adapta";
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.SShrike ];
  };

  src = fetchFromGitHub {
    owner = "tista500";
    repo = "Adapta";
    rev = version;
    sha256 = "08g941xgxg7i8g1srn3zdxz1nxm24bkrg5cx9ipjqk5cwsck7470";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ autoreconfHook parallel sassc inkscape libxml2 glib.dev ];

  buildInputs = [ gdk_pixbuf librsvg gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  configureFlags = "--disable-unity";
}
