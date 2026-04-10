{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "forgit";
  version = "26.04.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-/tG//6s0km8IUJXI4f++/UUCTAOYTDE/C5bbkHFhdNY=";
  };

  postInstall = ''
    cp -r bin $out/share/fish/vendor_conf.d/
  '';

  meta = {
    description = "Utility tool powered by fzf for using git interactively";
    homepage = "https://github.com/wfxr/forgit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
