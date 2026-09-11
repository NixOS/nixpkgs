{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "stream-sts";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-stream-sts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yquPvEhfY1nb+BLnDDyzC1d4Jp49mO5tonlQM+MMssk=";
  };

  meta = {
    description = "Stream server traffic status core module";
    homepage = "https://github.com/vozlt/nginx-module-stream-sts";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
