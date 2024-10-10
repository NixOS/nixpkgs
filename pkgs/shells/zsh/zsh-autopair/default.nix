{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zsh-autopair";
  version = "1.0-unstable-2024-07-14";

  src = fetchFromGitHub {
    owner = "hlissner";
    repo = "zsh-autopair";
    rev = "449a7c3d095bc8f3d78cf37b9549f8bb4c383f3d";
    hash = "sha256-3zvOgIi+q7+sTXrT+r/4v98qjeiEL4Wh64rxBYnwJvQ=";
  };

  installPhase = ''
    install -D autopair.zsh $out/share/zsh/${pname}/autopair.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/hlissner/zsh-autopair";
    description = "Plugin that auto-closes, deletes and skips over matching delimiters in zsh intelligently";
    license = licenses.mit;
    maintainers = with maintainers; [
      _0qq
      DataHearth
    ];
    platforms = platforms.all;
  };
}
