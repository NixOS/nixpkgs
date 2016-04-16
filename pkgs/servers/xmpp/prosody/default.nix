{ stdenv, fetchurl, libidn, openssl, makeWrapper, fetchhg
, lua5, luasocket, luasec, luaexpat, luafilesystem, luabitop
, luaevent ? null, luazlib ? null
, withLibevent ? true, withZlib ? true }:

assert withLibevent -> luaevent != null;
assert withZlib -> luazlib != null;

with stdenv.lib;

let
  libs        = [ luasocket luasec luaexpat luafilesystem luabitop ]
                ++ optional withLibevent luaevent
                ++ optional withZlib luazlib;
  getPath     = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath  = lib : getPath lib "lua";
  getLuaCPath = lib : getPath lib "so";
  luaPath     = concatStringsSep ";" (map getLuaPath  libs);
  luaCPath    = concatStringsSep ";" (map getLuaCPath libs);
in

stdenv.mkDerivation rec {
  version = "0.10-1nightly213";
  name = "prosody-${version}";

  src = fetchurl {
    url = "https://prosody.im/nightly/0.10/build213/${name}.tar.gz";
    sha256 = "03na7kdraq030a2mwss4pqiv98yr6yzv107h35ificzs843qagbr";
  };

  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules/";
    rev = "50c188cf0ae3";
    sha256 = "1hz1vn0llghvjq4h96sy96rqnidmylxky4hjwnmhvj23ij2b319f";
  };

  buildInputs = [ lua5 luasocket luasec luaexpat luabitop libidn openssl makeWrapper ]
                ++ optional withLibevent luaevent
                ++ optional withZlib luazlib;

  configureFlags = [
    "--ostype=linux"
    "--with-lua-include=${lua5}/include"
    "--with-lua=${lua5}"
  ];

  postInstall = ''
      mkdir $modules
      cp -r $communityModules/* $modules

      wrapProgram $out/bin/prosody \
        --set LUA_PATH '"${luaPath};"' \
        --set LUA_CPATH '"${luaCPath};"'
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --set LUA_PATH '"${luaPath};"' \
        --set LUA_CPATH '"${luaCPath};"'
    '';

  outputs = [ "out" "modules" ];
  setOutputFlags = false;

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = http://www.prosody.im;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
  };
}
