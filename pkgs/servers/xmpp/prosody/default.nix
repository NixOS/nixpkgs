{ stdenv, fetchurl, lua5, luasocket, luasec, luaexpat, luafilesystem, luabitop, libidn, openssl, makeWrapper, fetchhg }:

let
  libs        = [ luasocket luasec luaexpat luafilesystem luabitop ];
  getPath     = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath  = lib : getPath lib "lua";
  getLuaCPath = lib : getPath lib "so";
  luaPath     = stdenv.lib.concatStringsSep ";" (map getLuaPath  libs);
  luaCPath    = stdenv.lib.concatStringsSep ";" (map getLuaCPath libs);
in

stdenv.mkDerivation rec {
  version = "0.9.6";
  name = "prosody-${version}";
  src = fetchurl {
    url = "http://prosody.im/downloads/source/${name}.tar.gz";
    sha256 = "1rs0aqn1rkddgfq9pm7mi7xm5lbvxjpf8d8ijc085fc90zwqq8bm";
  };

  communityModules = fetchhg {
    url = "http://prosody-modules.googlecode.com/hg/";
    rev = "4b55110b0aa8";
    sha256 = "0010x2rl9f9ihy2nwqan2jdlz25433srj2zna1xh10490mc28hij";
  };

  buildInputs = [ lua5 luasocket luasec luaexpat luabitop libidn openssl makeWrapper ];

  configureFlags = [
    "--ostype=linux"
    "--with-lua-include=${lua5}/include"
    "--with-lua=${lua5}"
  ];

  postInstall = ''
      cp $communityModules/mod_websocket/mod_websocket.lua $out/lib/prosody/modules/
      wrapProgram $out/bin/prosody \
        --set LUA_PATH '"${luaPath};"' \
        --set LUA_CPATH '"${luaCPath};"'
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --set LUA_PATH '"${luaPath};"' \
        --set LUA_CPATH '"${luaCPath};"'
    '';

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = stdenv.lib.licenses.mit;
    homepage = http://www.prosody.im;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
