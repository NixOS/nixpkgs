{ stdenv, fetchFromGitHub, autoreconfHook, sass, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "greybird";
  version = "3.22.6";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "16rifkyy8l4v03rx85j7m6rfdal99l1xdmghysh95r6lx4y6r01i";
  };

  nativeBuildInputs = [ autoreconfHook sass glib libxml2 gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = {
    description = "Grey and blue theme (Gtk, Xfce, Emerald, Metacity, Mutter, Unity)";
    homepage = https://github.com/shimmerproject/Greybird;
    license = with stdenv.lib.licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
