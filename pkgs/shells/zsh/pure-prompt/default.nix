{ lib, stdenv, fetchFromGitHub }:

with lib;

stdenv.mkDerivation rec {
  pname = "pure-prompt";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "v${version}";
    sha256 = "sha256-bWp04xT+/Xhgxj1Rm0FgTkRtLH9nuSFtqBsO3B7Exvo=";
  };

  installPhase = ''
    OUTDIR="$out/share/zsh/site-functions"
    mkdir -p "$OUTDIR"
    cp pure.zsh "$OUTDIR/prompt_pure_setup"
    cp async.zsh "$OUTDIR/async"
  '';

  meta = {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien pablovsky ];
  };
}
