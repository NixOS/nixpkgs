{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.2.1";
  name = "antigen-${version}";

  src = fetchurl {
    url = "https://github.com/zsh-users/antigen/releases/download/v${version}/antigen.zsh";
    sha256 = "0s32280ak0gd0rr66g5dj6r5px0si8w47bcxlqfpaijg7i8xk1i7";
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
