{ lib, stdenv, fetchurl, libxslt, docbook_xsl, docbook_xml_dtd_45, pcre, withZ3 ? true, z3 }:

stdenv.mkDerivation rec {
  pname = "cppcheck";
  version = "2.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-rHTAlzxGoFJ2D0/3ymqEYWyleVUQVC0ZWm8SLFMHkpE=";
  };

  buildInputs = [ pcre ] ++ lib.optionals withZ3 [ z3 ];
  nativeBuildInputs = [ libxslt docbook_xsl docbook_xml_dtd_45 ];

  makeFlags = [ "PREFIX=$(out)" "FILESDIR=$(out)/cfg" "HAVE_RULES=yes" ]
   ++ lib.optionals withZ3 [ "USE_Z3=yes" "CPPFLAGS=-DNEW_Z3=1" ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;

  postInstall = ''
    make DB2MAN=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl man
    mkdir -p $man/share/man/man1
    cp cppcheck.1 $man/share/man/man1/cppcheck.1
  '';

  meta = with lib; {
    description = "A static analysis tool for C/C++ code";
    longDescription = ''
      Check C/C++ code for memory leaks, mismatching allocation-deallocation,
      buffer overruns and more.
    '';
    homepage = "http://cppcheck.sourceforge.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joachifm ];
  };
}
