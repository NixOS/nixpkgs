{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.2.2";
  name = "antigen-${version}";

  src = fetchurl {
    url = "https://github.com/zsh-users/antigen/releases/download/v${version}/antigen.zsh";
    sha256 = "0635dvnsqh7dpqdwx5qq3kx7m1cx2038zln6y9ycnbi3i0ilgj9z";
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
