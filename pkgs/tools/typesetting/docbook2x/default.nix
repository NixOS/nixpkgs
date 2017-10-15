{ fetchurl, stdenv, lib, texinfo, perl
, XMLSAX, XMLParser, XMLNamespaceSupport
, groff, libxml2, libxslt, gnused, libiconv, opensp
, docbook_xml_dtd_43, findXMLCatalogs
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "docbook2X-0.8.8";

  src = fetchurl {
    url = "mirror://sourceforge/docbook2x/${name}.tar.gz";
    sha256 = "0ifwzk99rzjws0ixzimbvs83x6cxqk1xzmg84wa1p7bs6rypaxs0";
  };

  # This patch makes sure that `docbook2texi --to-stdout' actually
  # writes its output to stdout instead of creating a file.
  patches = [ ./db2x_texixml-to-stdout.patch ];

  nativeBuildInputs = [ findXMLCatalogs makeWrapper ];
  buildInputs = [ perl texinfo groff libxml2 libxslt docbook_xml_dtd_43
                  XMLSAX XMLParser XMLNamespaceSupport opensp libiconv
                ];

  postConfigure = ''
    # Broken substitution is used for `perl/config.pl', which leaves literal
    # `$prefix' in it.
    substituteInPlace "perl/config.pl"       \
      --replace '${"\$" + "{prefix}"}' "$out"
  '';

  postInstall = ''
    perlPrograms="db2x_manxml db2x_texixml db2x_xsltproc
                  docbook2man docbook2texi";
    for i in $perlPrograms
    do
      wrapProgram $out/bin/$i \
        --set PERL5LIB \
          "${lib.makePerlPath [ XMLSAX XMLParser XMLNamespaceSupport ]}" \
        --set XML_CATALOG_FILES "$XML_CATALOG_FILES"
    done

    wrapProgram $out/bin/sgml2xml-isoent --prefix PATH : \
      "${gnused}/bin"
  '';

  meta = with stdenv.lib; {
    longDescription = ''
      docbook2X is a software package that converts DocBook documents
      into the traditional Unix man page format and the GNU Texinfo
      format.
    '';
    license = licenses.mit;
    homepage = http://docbook2x.sourceforge.net/;
    platforms = platforms.all;
  };
}
