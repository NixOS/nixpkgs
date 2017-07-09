{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.2.1";
  name = "antigen";

  src = fetchurl {
    url = "git.io/antigen";
    sha256 = "0phnijkdl6w3cfbwakdvc86hazdn6y42bqnr1g3wynax5jr56xqm";
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
