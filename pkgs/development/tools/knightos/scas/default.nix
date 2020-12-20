{ fetchFromGitHub, stdenv, cmake }:

stdenv.mkDerivation rec {
  pname = "scas";

  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "scas";
    rev = version;
    sha256 = "0z6r07cl92kq860ddas5p88l990ih9cfqlzy5y4mk5hrmjzya60j";
  };

  cmakeFlags = [ "-DSCAS_LIBRARY=1" ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "Assembler and linker for the Z80";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
