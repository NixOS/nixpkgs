{
  fetchFromGitHub,
  lib,
  luajit_openresty,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "lua-upstream";
  version = "0.07";

  src = fetchFromGitHub {
    name = "lua-upstream";
    owner = "openresty";
    repo = "lua-upstream-nginx-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-886qZB6gTOyWW0riMgQ8osrF3Q/7DxBSHJHmqNBjDL8=";
  };

  buildInputs = [ luajit_openresty ];

  allowMemoryWriteExecute = true;

  meta = {
    description = "Expose Lua API to ngx_lua for Nginx upstreams";
    homepage = "https://github.com/openresty/lua-upstream-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    broken = true; # Build against nginx fails
  };
})
