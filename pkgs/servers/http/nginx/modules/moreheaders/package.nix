{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "moreheaders";
  version = "0.41";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "headers-more-nginx-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gRcFUxebEZcO5vjoyqtIIorVK+B9r0YlooLYMoztCDk=";
  };

  meta = {
    description = "Set, add, and clear arbitrary output headers";
    homepage = "https://github.com/openresty/headers-more-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
