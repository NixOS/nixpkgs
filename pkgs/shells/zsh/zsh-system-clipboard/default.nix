{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-system-clipboard";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "kutsan";
    repo = "zsh-system-clipboard";
    rev = "v${version}";
    sha256 = "09lqav1mz5zajklr3xa0iaivhpykv3azkjb7yj9wyp0hq3vymp8i";
  };

  strictDeps = true;
  installPhase = ''
    install -D zsh-system-clipboard.zsh $out/share/zsh/${pname}/zsh-system-clipboard.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/kutsan/zsh-system-clipboard";
    description = "A plugin that adds key bindings support for ZLE (Zsh Line Editor) clipboard operations for vi emulation keymaps";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ _0qq ];
    platforms = platforms.all;
  };
}
