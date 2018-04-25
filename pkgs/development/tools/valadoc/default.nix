{stdenv, fetchurl, gnome3, automake, autoconf, which, libtool, pkgconfig, graphviz, glib, gobjectIntrospection, expat}:
stdenv.mkDerivation rec {
  version = "0.36.1";
  name = "valadoc-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/valadoc/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "07501k2j9c016bd7rfr6xzaxdplq7j9sd18b5ixbqdbipvn6whnv";
  };

  nativeBuildInputs = [ automake autoconf which gnome3.vala libtool pkgconfig gobjectIntrospection ];
  buildInputs = [ graphviz glib gnome3.libgee expat ];

  preConfigure = "./autogen.sh";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "valadoc";
    };
  };

  meta = with stdenv.lib; {
    description = "valadoc is a documentation generator for generating API documentation from Vala source code";
    homepage = http://valadoc.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = with platforms; linux;
  };
}
