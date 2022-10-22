{ lib
, stdenv
, fetchFromGitHub
, pcre
, python3
, libxslt
, docbook_xsl
, docbook_xml_dtd_45
, withZ3 ? true
, z3
, which
}:

stdenv.mkDerivation rec {
  pname = "cppcheck";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "danmar";
    repo = "cppcheck";
    rev = version;
    sha256 = "sha256-UkmtW/3CLU9tFNjVLhQPhYkYflFLOBc/7Qc8lSBOo3I=";
  };

  buildInputs = [ pcre
    (python3.withPackages (ps: [ps.pygments]))
  ] ++ lib.optionals withZ3 [ z3 ];
  nativeBuildInputs = [ libxslt docbook_xsl docbook_xml_dtd_45 which ];

  makeFlags = [ "PREFIX=$(out)" "MATCHCOMPILER=yes" "FILESDIR=$(out)/share/cppcheck" "HAVE_RULES=yes" ]
   ++ lib.optionals withZ3 [ "USE_Z3=yes" "CPPFLAGS=-DNEW_Z3=1" ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;

  doCheck = true;

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
