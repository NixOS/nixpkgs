{ stdenv, fetchFromGitHub, autoreconfHook, sass, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "Greybird";
  version = "2016-08-16";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = "${pname}";
    owner = "shimmerproject";
    rev = "fcaa400df68b1a29bb9dc8eb9c772a241f17c9ea";
    sha256 = "02f2zlkhi2als39ajq3v91iik708g5a9iyl3cvd65n80gr4jifmr";
  };

  nativeBuildInputs = [ autoreconfHook sass glib libxml2 gdk_pixbuf librsvg ];

  buildInputs = [ gtk-engine-murrine ];
  
  meta = {
    description = "Grey and blue theme (Gtk, Xfce, Emerald, Metacity, Mutter, Unity)";
    homepage = http://shimmerproject.org/our-projects/greybird/;
    license = with stdenv.lib.licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
