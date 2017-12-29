{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "FlameGraph-2017-07-01";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "FlameGraph";
    rev = "a93d905911c07c96a73b35ddbcb5ddb2f39da4b6";
    sha256 = "07z2ffnab41dz833wwgr875vjccqyh0238357g7ml1yg5445x2jy";
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
