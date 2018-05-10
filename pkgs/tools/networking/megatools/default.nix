{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, fuse, curl, glib-networking
, asciidoc, libxml2, docbook_xsl, docbook_xml_dtd_45, libxslt, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "megatools-${version}";
  version = "2017-10-26";

  src = fetchFromGitHub {
    owner = "megous";
    repo = "megatools";
    rev = "35dfba3262f620b4701ec1975293463957e20f26";
    sha256 = "0xphgv78j731rmhxic4fwzdr7vq5px921qifrw1y40b93nhy4d5n";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig wrapGAppsHook asciidoc libxml2
    docbook_xsl docbook_xml_dtd_45 libxslt
  ];
  buildInputs = [ glib glib-networking fuse curl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Command line client for Mega.co.nz";
    homepage = https://megatools.megous.com/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
