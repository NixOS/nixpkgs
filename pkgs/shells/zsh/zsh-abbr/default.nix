{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "zsh-abbr";
  version = "5.8.3";

  src = fetchFromGitHub {
    owner = "olets";
    repo = "zsh-abbr";
    rev = "v${version}";
    hash = "sha256-Kl98S1S4Ds9TF3H1YOjwds38da++/5rpgO/oAfKwRrc=";
  };

  strictDeps = true;

  installPhase = ''
    install -D zsh-abbr.plugin.zsh $out/share/zsh/${pname}/zsh-abbr.plugin.zsh
    install -D zsh-abbr.zsh        $out/share/zsh/${pname}/zsh-abbr.zsh
    install -D completions/_abbr   $out/share/zsh/${pname}/completions/_abbr

    # Required for `man` to find the manpage of abbr, since it looks via PATH
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
