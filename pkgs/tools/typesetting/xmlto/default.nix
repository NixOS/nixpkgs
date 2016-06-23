{ fetchurl, stdenv, flex, libxml2, libxslt
, docbook_xml_dtd_42, docbook_xsl, w3m
, bash, getopt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xmlto-0.0.26";
  src = fetchurl {
    url = "http://fedorahosted.org/releases/x/m/xmlto/${name}.tar.bz2";
    sha256 = "1v5mahfg5k9lh3anykl482xnrgxn36zlmqsgwahw29xwncprpd7g";
  };

  patchPhase = ''
    substituteInPlace "xmlto.in" \
      --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace "xmlto.in" \
      --replace "/usr/bin/locale" "$(type -P locale)"
    substituteInPlace "xmlto.in" \
      --replace "mktemp" "$(type -P mktemp)"
  '';

  # `libxml2' provides `xmllint', needed at build-time and run-time.
  # `libxslt' provides `xsltproc', used by `xmlto' at run-time.
  buildInputs = [ libxml2 libxslt docbook_xml_dtd_42 docbook_xsl getopt makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/xmlto" \
       --prefix PATH : "${libxslt.bin}/bin:${libxml2.bin}/bin:${getopt}/bin"

    # `w3m' is needed for HTML to text conversions.
    substituteInPlace "$out/share/xmlto/format/docbook/txt" \
      --replace "/usr/bin/w3m" "${w3m}/bin/w3m"
  '';

  meta = {
    description = "Front-end to an XSL toolchain";

    longDescription = ''
      xmlto is a front-end to an XSL toolchain.  It chooses an
      appropriate stylesheet for the conversion you want and applies
      it using an external XSL-T processor.  It also performs any
      necessary post-processing.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    homepage = https://fedorahosted.org/xmlto/;
  };
}
