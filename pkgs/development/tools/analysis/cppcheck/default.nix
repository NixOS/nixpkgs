{ stdenv, fetchurl, libxslt, docbook_xsl, docbook_xml_dtd_45 }:

let
  pname = "cppcheck";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.73";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "0l7yslf311h3kidi91q4zhqj3f3vsjp1gb2z50y20423fda87xin";
  };

  nativeBuildInputs = [ libxslt docbook_xsl docbook_xml_dtd_45 ];

  makeFlags = ''PREFIX=$(out) CFGDIR=$(out)/cfg'';

  outputs = [ "out" "man" ];

  postInstall = ''
    make DB2MAN=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl man
    mkdir -p $man/share/man/man1
    cp cppcheck.1 $man/share/man/man1/cppcheck.1
  '';

  meta = with stdenv.lib; {
    description = "A static analysis tool for C/C++ code";
    longDescription = ''
      Check C/C++ code for memory leaks, mismatching
      allocation-deallocation, buffer overruns and more.
    '';
    homepage = http://cppcheck.sourceforge.net/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joachifm ];
  };
}
