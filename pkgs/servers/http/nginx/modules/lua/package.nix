{
  fetchFromGitHub,
  lib,
  luajit_openresty,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "lua";
  version = "0.10.29";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "lua-nginx-module";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z62Vwrthl1FJiTdrdhifZZe6crdi8c6sTkUim6KmVlU=";
  };

  buildInputs = [ luajit_openresty ];

  preConfigure = ''
    export LUAJIT_LIB="${luajit_openresty}/lib"
    export LUAJIT_INC="$(realpath ${luajit_openresty}/include/luajit-*)"

    # make source directory writable to allow generating src/ngx_http_lua_autoconf.h
    lua_src=$TMPDIR/lua-src
    cp -r "${finalAttrs.src}/" "$lua_src"
    chmod -R +w "$lua_src"
    export configureFlags="''${configureFlags//"${finalAttrs.src}"/"$lua_src"}"
    unset lua_src
  '';

  allowMemoryWriteExecute = true;

  meta = {
    description = "Embed the Power of Lua";
    homepage = "https://github.com/openresty/lua-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
