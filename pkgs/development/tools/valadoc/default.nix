{stdenv, fetchgit, gnome3, automake, autoconf, which, libtool, pkgconfig, graphviz, glib, gobjectIntrospection, expat}:
stdenv.mkDerivation rec {
  version = "2016-11-11";
  name = "valadoc-unstable-${version}";

  src = fetchgit {
    url = "git://git.gnome.org/valadoc";
    rev = "8080b626db9c16ac9a0a9802677b4f6ab0d36d4e";
    sha256 = "1y00yls4wgxggzfagm3hcmzkpskfbs3m52pjgl71lg4p85kv6msv";
  };

  nativeBuildInputs = [ automake autoconf which gnome3.vala libtool pkgconfig gobjectIntrospection ];
  buildInputs = [ graphviz glib gnome3.libgee expat ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "valadoc is a documentation generator for generating API documentation from Vala source code";
    homepage = http://valadoc.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = with platforms; linux;
  };
}
