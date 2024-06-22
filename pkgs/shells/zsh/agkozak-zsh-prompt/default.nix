{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "agkozak-zsh-prompt";
  version = "3.11.3";

  src = fetchFromGitHub {
    owner = "agkozak";
    repo = "agkozak-zsh-prompt";
    rev = "v${version}";
    sha256 = "sha256-YBqFA/DK2K1effniwjPSe5VMx9tZGbmxyJp92TiingU=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/site-functions"

    mkdir -p "$plugindir"
    cp -r -- lib/*.zsh agkozak-zsh-prompt.plugin.zsh prompt_agkozak-zsh-prompt_setup "$plugindir"/
  '';

  meta = with lib; {
    description = "Fast, asynchronous Zsh prompt";
    homepage = "https://github.com/agkozak/agkozak-zsh-prompt";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ambroisie ];
  };
}
