{ stdenv, fetchFromGitHub, cmake, bison, flex, boost }:

stdenv.mkDerivation rec {
  pname = "kcc";

  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kcc";
    rev = version;
    sha256 = "1cd226nqbxq32mppkljavq1kb74jqfqns9r7fskszr42hbygynk4";
  };

  nativeBuildInputs = [ cmake bison flex ];

  buildInputs = [ boost ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "KnightOS C compiler";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
