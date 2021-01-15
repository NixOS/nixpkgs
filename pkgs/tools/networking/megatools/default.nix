{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, glib, fuse, curl, glib-networking
, asciidoc, libxml2, docbook_xsl, docbook_xml_dtd_45, libxslt, wrapGAppsNoGuiHook }:

stdenv.mkDerivation rec {
  pname = "megatools";
  version = "1.10.3";

  src = fetchgit {
    url = "https://megous.com/git/megatools";
    rev = "5581d06e447b84d0101d36dc96ab72920eec1017";
    sha256 = "1fh456kjsmdvpmvklkpi06h720yvhahd4rxa6cm5x818pl44p1r4";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config wrapGAppsNoGuiHook asciidoc libxml2
    docbook_xsl docbook_xml_dtd_45 libxslt
  ];
  buildInputs = [ glib glib-networking curl ]
  ++ lib.optionals stdenv.isLinux [ fuse ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Command line client for Mega.co.nz";
    homepage = "https://megatools.megous.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric AndersonTorres zowoq ];
    platforms = platforms.unix;
  };
}
