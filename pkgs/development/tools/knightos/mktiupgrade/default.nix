{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  pname = "mktiupgrade";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "mktiupgrade";
    rev = version;
    sha256 = "15y3rxvv7ipgc80wrvrpksxzdyqr21ywysc9hg6s7d3w8lqdq8dm";
  };

  nativeBuildInputs = [ asciidoc cmake ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "Makes TI calculator upgrade files from ROM dumps";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
