{ stdenv, fetchFromGitHub, makeWrapper, ... }:

stdenv.mkDerivation rec {
  pname = "gdub";
  version = "0.2.0";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "dougborg";
    repo = "gdub";
    rev = "v${version}";
    sha256 = "0ddb5y5n02ajj7n07i8a6v833w67ls9adasvl9zwn73s98fg2w8j";
  };

  preferLocalBuild = true;
  dontBuild = true;

  phases = "installPhase";

  installPhase = ''
    outdir=$out/share/gdub/bin
    mkdir -p $outdir
    cp -r $src/bin/gw $outdir
    chmod +x $outdir/gw
    makeWrapper $outdir/gw $out/bin/gw \
  '';

  meta = with stdenv.lib; {
    description = "A gradlew / gradle wrapper.";
    homepage = "https://www.gdub.rocks/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [maintainers.larusso];
  };
}
