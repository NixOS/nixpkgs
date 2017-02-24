{ stdenv, fetchFromGitHub, autoreconfHook, sass, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "greybird";
  version = "2017-02-17";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "${pname}";
    rev = "46afa0f1566207c07ce15633d3a4ca12075afcb7";
    sha256 = "0sxpj8k0dlgh1k1w1hnpy94rvh7h6mj9vrhldmhc128kncdcxk3j";
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
