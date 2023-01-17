{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pure-prompt";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "v${version}";
    sha256 = "sha256-e1D+9EejlVZxOyErg6eRgawth5gAhv6KpgjhK06ErZc=";
  };

  strictDeps = true;
  installPhase = ''
    OUTDIR="$out/share/zsh/site-functions"
    mkdir -p "$OUTDIR"
    cp pure.zsh "$OUTDIR/prompt_pure_setup"
    cp async.zsh "$OUTDIR/async"
  '';

  meta = with lib; {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien pablovsky ];
  };
}
