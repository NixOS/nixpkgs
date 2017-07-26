{ stdenv, fetchurl, pkgconfig, glib, fuse, curl, glib_networking
, asciidoc, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "megatools-${version}";
  version = "1.9.98";

  src = fetchurl {
    url = "http://megatools.megous.com/builds/${name}.tar.gz";
    sha256 = "0vx1farp0dpg4zwvxdbfdnzjk9qx3sn109p1r1zl3g3xsaj221cv";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook asciidoc ];
  buildInputs = [ glib glib_networking fuse curl ];

  meta = with stdenv.lib; {
    description = "Command line client for Mega.co.nz";
    homepage = http://megatools.megous.com/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
