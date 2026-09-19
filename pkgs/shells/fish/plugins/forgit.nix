{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin (finalAttrs: {
  pname = "forgit";
  version = "26.09.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    tag = finalAttrs.version;
    hash = "sha256-02w+BGrRDEFWLtH6tniiTgs+FHmghiHn9FMxO+U4wrI=";
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
