{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "zsh-abbr";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "olets";
    repo = "zsh-abbr";
    rev = "v${version}";
    hash = "sha256-bsacP1f1daSYfgMvXduWQ64JJXnrFiLYURENKSMA9LM=";
  };

  strictDeps = true;

  installPhase = ''
    install -D zsh-abbr.zsh $out/share/zsh/${pname}/abbr.plugin.zsh
    # Needed so that `man` can find the manpage, since it looks via PATH
    mkdir -p $out/bin
    mv man $out/share/man
  '';

  meta = with lib; {
    homepage = "https://github.com/olets/zsh-abbr";
    description = "Zsh manager for auto-expanding abbreviations, inspired by fish shell";
    license = with licenses; [cc-by-nc-nd-40 hl3];
    maintainers = with maintainers; [icy-thought];
    platforms = platforms.all;
  };
}
