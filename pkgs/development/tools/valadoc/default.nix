{stdenv, fetchurl, gnome3, automake, autoconf, which, libtool, pkgconfig, graphviz, glib, gobject-introspection, expat}:
stdenv.mkDerivation rec {
  version = "0.36.2";
  name = "valadoc-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/valadoc/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0hfaskbm7y4z4jf6lxm8hg4c0b8621qn1gchxjxcngq0cpx79z9h";
  };

  nativeBuildInputs = [ automake autoconf which gnome3.vala libtool pkgconfig gobject-introspection ];
  buildInputs = [ graphviz glib gnome3.libgee expat ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "valadoc";
    };
  };

  meta = with stdenv.lib; {
    description = "A documentation generator for generating API documentation from Vala source code";
    homepage    = https://valadoc.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ sternenseemann ];
    platforms   = platforms.linux;
  };
}
