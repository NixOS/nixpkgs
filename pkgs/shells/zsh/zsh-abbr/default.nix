{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "zsh-abbr";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "olets";
    repo = "zsh-abbr";
    rev = "v${version}";
    hash = "sha256-TdTjIt8SmwxXJqfaaCyBnBRzMm1Ux1nELGTkpY2Lmrc=";
  };

  strictDeps = true;

  installPhase = ''
    install -D zsh-abbr.zsh $out/share/zsh/${pname}/abbr.plugin.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/olets/zsh-abbr";
    description = "The zsh manager for auto-expanding abbreviations, inspired by fish shell";
    license = with licenses; [cc-by-nc-nd-40 hl3];
    maintainers = with maintainers; [icy-thought];
    platforms = platforms.all;
  };
}
