{ lib, buildFishPlugin, fetchFromGitHub, git, fzf }:

buildFishPlugin rec {
  pname = "forgit";
  version = "unstable-2022-08-16";

  preFixup = ''
    substituteInPlace $out/share/fish/vendor_conf.d/forgit.plugin.fish \
      --replace "fzf " "${fzf}/bin/fzf " \
      --replace "git " "${git}/bin/git "
  '';

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = "3f50933f047510020428114551da0ee5cdfb32a3";
    sha256 = "sha256-TSF4Vr5uf/+MVU4yCdIHNnwB7kkp4mF+hkhKtLqQvmk=";
  };

  meta = with lib; {
    description = "A utility tool powered by fzf for using git interactively.";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
