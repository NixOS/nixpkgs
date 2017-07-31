{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, parallel, sassc, inkscape, libxml2, glib, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.90.0.125";

  meta = with stdenv.lib; {
    description = "An adaptive GTK+ theme based on Material Design";
    homepage = https://github.com/tista500/Adapta;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };

  src = fetchFromGitHub {
    owner = "tista500";
    repo = "Adapta";
    rev = version;
    sha256 = "0abww5rcbn478w2kdhjlf68bfj8yf8i02nlmrjpp7j1v14r32xr0";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [ autoreconfHook pkgconfig parallel sassc inkscape libxml2 glib.dev ];

  buildInputs = [ gdk_pixbuf librsvg gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  configureFlags = "--disable-unity";
}
