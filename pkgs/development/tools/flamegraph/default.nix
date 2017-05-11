{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "FlameGraph-2017-05-11";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "FlameGraph";
    rev = "6b2a446dfb5d8027a0adf14adf71748aa502c247";
    sha256 = "11j1776zsvhn9digqay1cbfhhxz01nv2hm44i4gnpqcxkada44l2";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    for x in $src/*.pl $src/*.awk $src/dev/*.pl $src/dev/*.d; do
      cp $x $out/bin
    done
  '';

  meta = with stdenv.lib; {
    license = licenses.cddl;
    homepage = http://www.brendangregg.com/flamegraphs.html;
    description = "Visualization for profiled code";
    platforms = platforms.unix;
  };
}
