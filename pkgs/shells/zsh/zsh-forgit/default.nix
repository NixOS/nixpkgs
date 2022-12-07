{ stdenv, lib, fetchFromGitHub, git, fzf }:

stdenv.mkDerivation rec {
  pname = "zsh-forgit";
  version = "22.12.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    sha256 = "sha256-0juBNUJW4SU3Cl6ouD+xMYzlCJOL7NAYpueZ6V56/ck=";
  };

  strictDeps = true;

  postPatch = ''
    substituteInPlace forgit.plugin.zsh \
      --replace "fzf " "${fzf}/bin/fzf " \
      --replace "git " "${git}/bin/git "
  '';

  dontBuild = true;

  installPhase = ''
    install -D forgit.plugin.zsh $out/share/zsh/${pname}/forgit.plugin.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/wfxr/forgit";
    description = "A utility tool powered by fzf for using git interactively";
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
    platforms = platforms.all;
  };
}
