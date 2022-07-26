{ lib, buildFishPlugin, fetchFromGitHub, git, fzf }:

buildFishPlugin rec {
  pname = "forgit";
  version = "unstable-2021-12-05";

  preFixup = ''
    substituteInPlace $out/share/fish/vendor_conf.d/forgit.plugin.fish \
      --replace "fzf " "${fzf}/bin/fzf " \
      --replace "git " "${git}/bin/git "
  '';

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = "7b26cd46ac768af51b8dd4b84b6567c4e1c19642";
    sha256 = "sha256-S/alL3CiyedJ8aGhC2Vg9fmLJYcLxDe4EjQns5dZkKM=";
  };

  meta = with lib; {
    description = "A utility tool powered by fzf for using git interactively.";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
