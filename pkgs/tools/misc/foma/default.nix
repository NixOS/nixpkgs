{ stdenv, fetchFromGitHub, zlib, flex, bison, readline }:

stdenv.mkDerivation rec {
  pname = "foma";
  version = "0.9.18alpha";

  src = fetchFromGitHub {
    owner = "mhulden";
    repo = "foma";
    rev = "4456a40e81f46e3fe909c5a97a15fcf1d2a3b6c1";
    sha256 = "188yxj8wahlj2yf93rj1vx549j5cq0085d2jmj3vwzbfjq1mi1f0";
  };

  sourceRoot = "source/foma";

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ zlib readline ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace '-ltermcap' ' ' \
      --replace '/usr/local' '$(out)'
  '';

  meta = with stdenv.lib; {
    description = "A multi-purpose finite-state toolkit designed for applications ranging from natural language processing to research in automata theory";
    homepage = "https://github.com/mhulden/foma";
    license = licenses.asl20;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.all;
  };
}
