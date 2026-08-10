{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "vts";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-vts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3u4igVGBVsv+GNi3CSduZL6ZaOmdPoItUPA4+wmRw5Y=";
  };

  meta = {
    description = "Virtual host traffic status module";
    homepage = "https://github.com/vozlt/nginx-module-vts";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
