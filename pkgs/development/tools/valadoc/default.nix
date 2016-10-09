{stdenv, fetchgit, gnome3, automake, autoconf, which, libtool, pkgconfig, graphviz, glib, libgee_0_8, gobjectIntrospection, expat}:
stdenv.mkDerivation rec {
  version = "2016-10-09";
  name = "valadoc-unstable-${version}";

  src = fetchgit {
    url = "git://git.gnome.org/valadoc";
    rev = "37756970379d1363453562e9f2af2c354d172fb4";
    sha256 = "1s9sf6f0srh5sqqikswnb3bgwv5s1r9bd4n10hs2lzfmh7z227qb";
  };

  nativeBuildInputs = [ automake autoconf which gnome3.vala libtool pkgconfig gobjectIntrospection ];
  buildInputs = [ graphviz glib libgee_0_8 expat ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "valadoc is a documentation generator for generating API documentation from Vala source code";
    homepage = http://valadoc.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = with platforms; linux;
  };
}
