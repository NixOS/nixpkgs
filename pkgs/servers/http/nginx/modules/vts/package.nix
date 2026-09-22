{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "vts";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-vts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Cwjy3vrhyBohsroSB43qMvxZjIJtP/QHSK5QWnplzw=";
  };

  meta = {
    description = "Virtual host traffic status module";
    homepage = "https://github.com/vozlt/nginx-module-vts";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
