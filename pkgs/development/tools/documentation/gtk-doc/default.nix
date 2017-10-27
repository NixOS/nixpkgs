{ stdenv, fetchurl, autoreconfHook, pkgconfig, perl, python, libxml2Python, libxslt, which
, docbook_xml_dtd_43, docbook_xsl, gnome_doc_utils, dblatex, gettext, itstool }:

stdenv.mkDerivation rec {
  name = "gtk-doc-${version}";
  version = "1.25";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-doc/${version}/${name}.tar.xz";
    sha256 = "0hpxcij9xx9ny3gs9p0iz4r8zslw8wqymbyababiyl7603a6x90y";
  };

  patches = [
    ./respect-xml-catalog-files-var.patch
  ];

  outputDevdoc = "out";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
   [ pkgconfig perl python libxml2Python libxslt docbook_xml_dtd_43 docbook_xsl
     gnome_doc_utils dblatex gettext which itstool
   ];

  configureFlags = "--disable-scrollkeeper";

  meta = with stdenv.lib; {
    homepage = https://www.gtk.org/gtk-doc;
    description = "Tools to extract documentation embedded in GTK+ and GNOME source code";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
