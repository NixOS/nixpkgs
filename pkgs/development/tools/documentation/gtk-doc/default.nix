{ stdenv, fetchurl, autoreconfHook, pkgconfig, perl, python, libxml2Python, libxslt, which
, docbook_xml_dtd_43, docbook_xsl, gnome-doc-utils, dblatex, gettext, itstool }:

stdenv.mkDerivation rec {
  name = "gtk-doc-${version}";
  version = "1.25";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-doc/${version}/${name}.tar.xz";
    sha256 = "0hpxcij9xx9ny3gs9p0iz4r8zslw8wqymbyababiyl7603a6x90y";
  };

  patches = [
    passthru.respect_xml_catalog_files_var_patch
  ];

  outputDevdoc = "out";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
   [ pkgconfig perl python libxml2Python libxslt docbook_xml_dtd_43 docbook_xsl
     gnome-doc-utils dblatex gettext which itstool
   ];

  configureFlags = "--disable-scrollkeeper";

  passthru = {
    # Consumers are expected to copy the m4 files to their source tree, let them reuse the patch
    respect_xml_catalog_files_var_patch = ./respect-xml-catalog-files-var.patch;
  };

  meta = with stdenv.lib; {
    homepage = https://www.gtk.org/gtk-doc;
    description = "Tools to extract documentation embedded in GTK+ and GNOME source code";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
