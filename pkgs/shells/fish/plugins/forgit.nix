{ lib, buildFishPlugin, fetchFromGitHub, git, fzf }:

buildFishPlugin rec {
  pname = "forgit";
  version = "unstable-2021-04-09";

  preFixup = ''
    substituteInPlace $out/share/fish/vendor_conf.d/forgit.plugin.fish \
      --replace "fzf " "${fzf}/bin/fzf " \
      --replace "git " "${git}/bin/git "
  '';

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = "7806fc3ab37ac479c315eb54b164f67ba9ed17ea";
    sha256 = "sha256-a7wjuqXe3+y5zlgSLk5J31WoORbieFimvtr0FQHRY5M=";
  };

  meta = with lib; {
    description = "A utility tool powered by fzf for using git interactively.";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
