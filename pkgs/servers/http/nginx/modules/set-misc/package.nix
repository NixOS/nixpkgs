{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
  nginx,
  nginxModules,
}:

mkNginxPlugin (finalAttrs: {
  pname = "set-misc";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "set-misc-nginx-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2QHidYeKCELkWAdXwmMq9DsirK7I06gbsUVz6uJy+CI=";
  };

  passthru.tests.nginx = nginx.override {
    modules = [
      nginxModules.develkit
      finalAttrs.finalPackage
    ];
  };

  meta = {
    description = "Various set_xxx directives added to the rewrite module (md5/sha1, sql/json quoting and many more)";
    homepage = "https://github.com/openresty/set-misc-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
