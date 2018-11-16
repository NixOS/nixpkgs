{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.2.3";
  name = "antigen-${version}";

  src = fetchurl {
    url = "https://github.com/zsh-users/antigen/releases/download/v${version}/antigen.zsh";
    sha256 = "1bmp3qf14509swpxin4j9f98n05pdilzapjm0jdzbv0dy3hn20ix";
  };

  phases = "installPhase";

  installPhase = ''
    outdir=$out/share/antigen
    mkdir -p $outdir
    cp $src $outdir/antigen.zsh
  '';

  meta = {
    description = "The plugin manager for zsh.";
    homepage = http://antigen.sharats.me;
    license = stdenv.lib.licenses.mit;
  };
}
