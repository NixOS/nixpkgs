{ stdenv, fetchFromGitHub, autoreconfHook, sass, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "Greybird";
  version = "2016-11-15";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "${pname}";
    rev = "0a0853fa1de7545392f32aff33d95a8a1f6dca9e";
    sha256 = "0i9yvd265783pqij6rjh7pllw0l28v975mrahykcwvn9chq8rrqf";
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
