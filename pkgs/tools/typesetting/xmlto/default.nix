{ fetchurl, stdenv, flex, libxml2, libxslt
, docbook_xml_dtd_42, docbook_xsl, w3m
, bash, getopt, mktemp, findutils
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xmlto-0.0.20";
  src = fetchurl {
    url = "http://cyberelk.net/tim/data/xmlto/stable/${name}.tar.bz2";
    sha256 = "1s71khb0ycawhjpr19zrrqk0jac11jgwvxnajjkm2656p5qikylz";
  };

  patchPhase = ''
    substituteInPlace "xmlto.in" \
      --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace "xmlto.in" \
      --replace "/usr/bin/locale" "$(type -P locale)"
  '';

  configureFlags = ''
    --with-mktemp=${mktemp}/bin/mktemp
    --with-find=${findutils}/bin/find
    --with-bash=${bash}/bin/bash
    --with-getopt=${getopt}/bin/getopt
  '';

  # `libxml2' provides `xmllint', needed at build-time and run-time.
  # `libxslt' provides `xsltproc', used by `xmlto' at run-time.
  buildInputs = [ libxml2 libxslt docbook_xml_dtd_42 docbook_xsl makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/xmlto --prefix PATH : "${libxslt}/bin:${libxml2}/bin"

    # `w3m' is needed for HTML to text conversions.
    substituteInPlace "$out/share/xmlto/format/docbook/txt" \
      --replace "/usr/bin/w3m" "${w3m}/bin/w3m"
  '';

  meta = {
    description = "xmlto, a front-end to an XSL toolchain";

    longDescription = ''
      xmlto is a front-end to an XSL toolchain.  It chooses an
      appropriate stylesheet for the conversion you want and applies
      it using an external XSL-T processor.  It also performs any
      necessary post-processing.
    '';

    license = "GPLv2+";
    homepage = http://cyberelk.net/tim/software/xmlto/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
