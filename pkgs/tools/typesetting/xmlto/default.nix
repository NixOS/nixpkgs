{ fetchurl, stdenv, flex, libxml2, libxslt
, docbook_xml_dtd_42, docbook_xsl, w3m
, bash, getopt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xmlto-0.0.23";
  src = fetchurl {
    url = "http://fedorahosted.org/releases/x/m/xmlto/${name}.tar.bz2";
    sha256 = "1i5iihx304vj52nik42drs7z6z58m9szahng113r4mgd1mvb5zx9";
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
       --prefix PATH : "${libxslt}/bin:${libxml2}/bin:${getopt}/bin"

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
    homepage = https://fedorahosted.org/xmlto/;
  };
}
