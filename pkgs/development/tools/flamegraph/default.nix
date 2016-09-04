{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "FlameGraph-2015-10-10";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "FlameGraph";
    rev = "182b24fb635345d48c91ed1de58a08b620312f3d";
    sha256 = "1djz0wl8202a6j87ka9j3d8iw3bli056lrn73gv2i65p16rwk9kc";
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
