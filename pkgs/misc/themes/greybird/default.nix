{ stdenv, fetchFromGitHub, autoreconfHook, sass, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "Greybird";
  version = "2016-09-13";

  src = fetchFromGitHub {
    repo = "${pname}";
    owner = "shimmerproject";
    rev = "1942afc8732f904a1139fd41d7afd74263b87887";
    sha256 = "0qawc7rx5s3mnk5awvlbp6k5m9aj5krb1lasmgl2cb9fk09khf2v";
  };

  nativeBuildInputs = [ autoreconfHook sass glib libxml2 gdk_pixbuf librsvg ];

  buildInputs = [ gtk-engine-murrine ];
  
  meta = {
    description = "Grey and blue theme (Gtk, Xfce, Emerald, Metacity, Mutter, Unity)";
    homepage = https://github.com/shimmerproject/Greybird;
    license = with stdenv.lib.licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
