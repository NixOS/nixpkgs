{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin (finalAttrs: {
  pname = "forgit";
  version = "26.11.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    tag = finalAttrs.version;
    hash = "sha256-XjGNq7ezjX6xPTS0p/1b0An9fFGn3Xm+4ojuq2EZf1I=";
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
})
