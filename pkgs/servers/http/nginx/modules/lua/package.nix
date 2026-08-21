{
  fetchFromGitHub,
  lib,
  luajit_openresty,
  mkNginxPlugin,
  nixosTests,
}:

mkNginxPlugin (finalAttrs: {
  pname = "lua";
  # The version needs to fit to lua-resty-core.
  # Adapt both.
  version = "0.10.31";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "lua-nginx-module";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pS3Ce8duBtD1qb/E3NNnkuNU/39D4S9dJlGIfd9hkkc=";
  };

  buildInputs = [ luajit_openresty ];

  preConfigure = ''
    export LUAJIT_LIB="${luajit_openresty}/lib"
    export LUAJIT_INC="$(realpath ${luajit_openresty}/include/luajit-*)"
  '';

  allowMemoryWriteExecute = true;

  passthru.tests = {
    inherit (nixosTests) nginx-lua;
  };

  meta = {
    description = "Embed the Power of Lua";
    homepage = "https://github.com/openresty/lua-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
