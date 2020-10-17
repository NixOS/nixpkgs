{ stdenv, fetchFromGitHub, cmake, asciidoc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "kpack";

  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kpack";
    rev = version;
    sha256 = "0kakfbzdvq5ldv1gdzl473j73c9nfdyx4xzfkriglkrqmksqc329";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ asciidoc libxslt.bin docbook_xsl ];

  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "A tool to create or extract KnightOS packages";
    license     = licenses.lgpl2Only;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
