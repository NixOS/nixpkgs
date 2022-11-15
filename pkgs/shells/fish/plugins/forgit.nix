{ lib, buildFishPlugin, fetchFromGitHub, git, fzf }:

buildFishPlugin rec {
  pname = "forgit";
  version = "unstable-2022-10-14";

  preFixup = ''
    substituteInPlace $out/share/fish/vendor_conf.d/forgit.plugin.fish \
      --replace "fzf " "${fzf}/bin/fzf " \
      --replace "git " "${git}/bin/git "
  '';

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = "2872548075e63bc83a0b960e2813b16571998563";
    sha256 = "sha256-NKL4c4k9Nath8NQ3sWUTGUzp517jRX4v0qVaKMJSMrw=";
  };

  meta = with lib; {
    description = "A utility tool powered by fzf for using git interactively.";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
