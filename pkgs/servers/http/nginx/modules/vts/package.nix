{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "vts";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-vts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ReTmYGVSOwtnYDMkQDMWwxw09vT4iHYfYZvgd8iBotk=";
  };

  meta = {
    description = "Virtual host traffic status module";
    homepage = "https://github.com/vozlt/nginx-module-vts";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
