{ fetchurl, stdenv, texinfo, perl
, XMLSAX, XMLParser, XMLNamespaceSupport
, groff, libxml2, libxslt, gnused, libiconv
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

  buildInputs = [ perl texinfo groff libxml2 libxslt makeWrapper
                  XMLSAX XMLParser XMLNamespaceSupport
  	        ] ++ (if libiconv != null then [libiconv] else []);

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
      # XXX: We work around the fact that `wrapProgram' doesn't support
      # spaces below by inserting escaped backslashes.
      wrapProgram $out/bin/$i --prefix PERL5LIB :			\
        "${XMLSAX}/lib/perl5/site_perl:${XMLParser}/lib/perl5/site_perl" \
	--prefix PERL5LIB :						\
	"${XMLNamespaceSupport}/lib/perl5/site_perl"			\
	--prefix XML_CATALOG_FILES "\ "					\
	"$out/share/docbook2X/dtd/catalog.xml\ $out/share/docbook2X/xslt/catalog.xml"
    done

    wrapProgram $out/bin/sgml2xml-isoent --prefix PATH : \
      "${gnused}/bin"
  '';

  meta = {
    longDescription = ''
      docbook2X is a software package that converts DocBook documents
      into the traditional Unix man page format and the GNU Texinfo
      format.
    '';
    license = "MIT-style";
    homepage = http://docbook2x.sourceforge.net/;
  };
}
