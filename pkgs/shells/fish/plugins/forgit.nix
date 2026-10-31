{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin (finalAttrs: {
  pname = "forgit";
  version = "26.10.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    tag = finalAttrs.version;
    hash = "sha256-Kno14XqXwtG0zWVjrikoXf7eIXo3pj7YbSoQOYUcAI4=";
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
