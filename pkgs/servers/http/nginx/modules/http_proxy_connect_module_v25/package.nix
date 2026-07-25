{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "http_proxy_connect";
  version = "0.0.5-unstable-2023-06-19";

  src = fetchFromGitHub {
    owner = "chobits";
    repo = "ngx_http_proxy_connect_module";
    rev = "dcb9a2c614d376b820d774db510d4da12dfe1e5b";
    hash = "sha256-AzMhTSzmk3osSYy2q28/hko1v2AOTnY/dP5IprqGlQo=";
  };

  nginxPatches = [
    "${finalAttrs.src}/patch/proxy_connect_rewrite_102101.patch"
  ];

  passthru.supports = with lib.versions; version: major version == "1" && minor version == "25";

  meta = {
    description = "Forward proxy module for CONNECT request handling";
    homepage = "https://github.com/chobits/ngx_http_proxy_connect_module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
