{ stdenv, fetchFromGitHub, autoreconfHook, sass, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "greybird";
  version = "2017-02-26";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "${pname}";
    rev = "66c222c25c43603e73d3521e0e91ffb268214229";
    sha256 = "1q0nc02d7kwaxjb8d2rvwc3yf3v46r44zsighwjnmczpw7y3j6h8";
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
