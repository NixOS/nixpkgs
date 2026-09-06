{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "sts";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vozlt";
    repo = "nginx-module-sts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M1PXnLWniyZVjp3pjobmt23KMfGWNb9aPTH0QEwSa1s=";
  };

  meta = {
    description = "Stream server traffic status module";
    homepage = "https://github.com/vozlt/nginx-module-sts";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
