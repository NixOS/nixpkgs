{ fetchurl, stdenv, perl, perlXMLSAX
, groff, libxml2, libxslt, gnused
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "docbook2X-0.8.8";
  src = fetchurl {
    url = "mirror://sourceforge/docbook2x/${name}.tar.gz";
    sha256 = "0ifwzk99rzjws0ixzimbvs83x6cxqk1xzmg84wa1p7bs6rypaxs0";
  };

  buildInputs = [ perl groff libxml2 libxslt makeWrapper ];
  propagatedBuildInputs = [ perlXMLSAX ];

  postInstall = ''
    perl_programs="db2x_manxml db2x_texixml db2x_xsltproc
                   docbook2man docbook2texi";
    for i in $perl_programs
    do
      wrapProgram $out/bin/$i --prefix PERL5LIB : \
        "${perlXMLSAX}/lib/site_perl"
    done

    wrapProgram $out/bin/sgml2xml-isoent --prefix PATH : \
      "${gnused}/bin"
  '';

  meta = {
    description = ''docbook2X is a software package that converts DocBook
                    documents into the traditional Unix man page format
		    and the GNU Texinfo format.'';
    license = "MIT-style";
    homepage = http://docbook2x.sourceforge.net/;
  };
}
