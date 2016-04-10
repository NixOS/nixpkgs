{ stdenv, fetchurl, pkgconfig, perl, python, libxml2Python, libxslt, which
, docbook_xml_dtd_43, docbook_xsl, gnome_doc_utils, dblatex, gettext, itstool }:

stdenv.mkDerivation rec {
  name = "gtk-doc-${version}";
  version = "1.25";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-doc/${version}/${name}.tar.xz";
    sha256 = "0hpxcij9xx9ny3gs9p0iz4r8zslw8wqymbyababiyl7603a6x90y";
  };

  outputDocdev = "out";

  # maybe there is a better way to pass the needed dtd and xsl files
  # "-//OASIS//DTD DocBook XML V4.1.2//EN" and "http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"
  preConfigure = ''
    mkdir -p $out/nix-support
    cat > $out/nix-support/catalog.xml << EOF
    <?xml version="1.0"?>
    <!DOCTYPE catalog PUBLIC "-//OASIS//DTD Entity Resolution XML Catalog V1.0//EN" "http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd">
    <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
      <nextCatalog  catalog="${docbook_xsl}/xml/xsl/docbook/catalog.xml" />
      <nextCatalog  catalog="${docbook_xml_dtd_43}/xml/dtd/docbook/catalog.xml" />
    </catalog>
    EOF

    configureFlags="--with-xml-catalog=$out/nix-support/catalog.xml --disable-scrollkeeper";
  '';

  buildInputs =
   [ pkgconfig perl python libxml2Python libxslt docbook_xml_dtd_43 docbook_xsl
     gnome_doc_utils dblatex gettext which itstool
   ];

  meta = with stdenv.lib; {
    homepage = http://www.gtk.org/gtk-doc;
    description = "Tools to extract documentation embedded in GTK+ and GNOME source code";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
