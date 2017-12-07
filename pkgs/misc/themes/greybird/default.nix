{ stdenv, fetchFromGitHub, autoreconfHook, sass, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "greybird";
  version = "3.22.5";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0l107q9fcbgp73r4p4fmyy3a7pmc4mi4km5hgp67fm2a4dna7rkd";
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
