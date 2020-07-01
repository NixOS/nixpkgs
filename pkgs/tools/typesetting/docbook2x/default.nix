{ fetchurl, stdenv, texinfo, perlPackages
, groff, libxml2, libxslt, gnused, libiconv, opensp
, docbook_xml_dtd_43
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

  buildInputs = [ texinfo groff libxml2 libxslt makeWrapper opensp libiconv ]
    ++ (with perlPackages; [ perl XMLSAX XMLParser XMLNamespaceSupport ]);

  postConfigure = ''
    # Broken substitution is used for `perl/config.pl', which leaves literal
    # `$prefix' in it.
    substituteInPlace "perl/config.pl"       \
      --replace '${"\$" + "{prefix}"}' "$out"
  '';

  doCheck = false; # fails a lot of tests

  postInstall = ''
    perlPrograms="db2x_manxml db2x_texixml db2x_xsltproc
                  docbook2man docbook2texi";
    for i in $perlPrograms
    do
      # XXX: We work around the fact that `wrapProgram' doesn't support
      # spaces below by inserting escaped backslashes.
      wrapProgram $out/bin/$i \
        --prefix PERL5LIB : ${with perlPackages; makeFullPerlPath [XMLSAX XMLParser XMLNamespaceSupport]} \
        --prefix XML_CATALOG_FILES "\ " \
        "$out/share/docbook2X/dtd/catalog.xml\ $out/share/docbook2X/xslt/catalog.xml\ ${docbook_xml_dtd_43}/xml/dtd/docbook/catalog.xml"
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
    homepage = "http://docbook2x.sourceforge.net/";
    platforms = platforms.all;
  };
}
