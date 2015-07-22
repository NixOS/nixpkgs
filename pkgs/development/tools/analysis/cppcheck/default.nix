{ stdenv, fetchurl, libxslt, docbook_xsl, docbook_xml_dtd_45 }:

let
  name = "cppcheck";
  version = "1.69";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "0bjkqy4c6ph6nzparcnbxrdn52i3hiind4jc99v2kvsq281wimab";
  };

  buildInputs = [ libxslt docbook_xsl docbook_xml_dtd_45 ];

  makeFlags = ''PREFIX=$(out) CFGDIR=$(out)/cfg'';

  postInstall = ''
    make DB2MAN=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl man
    mkdir -p $out/share/man/man1
    cp cppcheck.1 $out/share/man/man1/cppcheck.1
  '';

  meta = {
    description = "A static analysis tool for C/C++ code";
    longDescription = ''
      Check C/C++ code for memory leaks, mismatching
      allocation-deallocation, buffer overruns and more.
    '';
    homepage = http://cppcheck.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
