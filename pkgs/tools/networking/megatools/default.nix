{ stdenv, fetchgit, autoreconfHook, pkgconfig, glib, fuse, curl, glib-networking
, asciidoc, libxml2, docbook_xsl, docbook_xml_dtd_45, libxslt, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "megatools";
  version = "1.10.2";

  src = fetchgit {
    url = "https://megous.com/git/megatools";
    rev = version;
    sha256 = "001hw8j36ld03wwaphq3xdaazf2dpl36h84k8xmk524x8vlia8lk";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig wrapGAppsHook asciidoc libxml2
    docbook_xsl docbook_xml_dtd_45 libxslt
  ];
  buildInputs = [ glib glib-networking curl ]
  ++ stdenv.lib.optionals stdenv.isLinux [ fuse ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Command line client for Mega.co.nz";
    homepage = https://megatools.megous.com/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
