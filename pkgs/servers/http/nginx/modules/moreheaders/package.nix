{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "moreheaders";
  version = "0.40";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "headers-more-nginx-module";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-4oddjLXtJyDmxCa2ocBtNAeKWXxI38I9eHeFVw9/ANc=";
  };

  meta = {
    description = "Set, add, and clear arbitrary output headers";
    homepage = "https://github.com/openresty/headers-more-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
