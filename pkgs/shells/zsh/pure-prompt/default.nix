{ lib, stdenv, fetchFromGitHub }:

with lib;

stdenv.mkDerivation rec {
  pname = "pure-prompt";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "v${version}";
    sha256 = "sha256-fnk4lLRASX7FFAovAiRd9sm4jNlnFIJ78UCzdsXYVfM=";
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
