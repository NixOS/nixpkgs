{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-z";
  version = "unstable-2021-02-15";

  src = fetchFromGitHub {
    owner = "agkozak";
    repo = pname;
    rev = "595c883abec4682929ffe05eb2d088dd18e97557";
    sha256 = "sha256-HnwUWqzwavh/Qox+siOe5lwTp7PBdiYx+9M0NMNFx00=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh-z
    cp _zshz zsh-z.plugin.zsh $out/share/zsh-z
  '';

  meta = with lib; {
    description = "Jump quickly to directories that you have visited frequently in the past, or recently";
    homepage = "https://github.com/agkozak/zsh-z";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.evalexpr ];
  };
}
