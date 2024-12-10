{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "FlameGraph";
  version = "2019-02-16";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = pname;
    rev = "1b1c6deede9c33c5134c920bdb7a44cc5528e9a7";
    sha256 = "1flvkmv2gbb003d51myl7r0wyhyw1bk9p7v19xagb8xjj4ci947b";
  };

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for x in $src/*.pl $src/*.awk $src/dev/*.pl $src/dev/*.d; do
      cp $x $out/bin
    done

    runHook postInstall
  '';

  meta = with lib; {
    license = with licenses; [
      asl20
      cddl
      gpl2Plus
    ];
    homepage = "http://www.brendangregg.com/flamegraphs.html";
    description = "Visualization for profiled code";
    platforms = platforms.unix;
  };
}
