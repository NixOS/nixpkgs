{ stdenv, fetchFromGitHub }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "pure-prompt";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "v${version}";
    sha256 = "0r4y8bglwdq85dwlxh9sm23ppzy1z7i8kmjny5mx9css0likj8qv";
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
