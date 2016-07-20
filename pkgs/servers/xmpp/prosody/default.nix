{ stdenv, fetchurl, libidn, openssl, makeWrapper, fetchhg
, lua5, luasocket, luasec, luaexpat, luafilesystem, luabitop
, lualdap, luadbi, luaevent ? null, luazlib ? null
, withLibevent ? true, withZlib ? true }:

assert withLibevent -> luaevent != null;
assert withZlib -> luazlib != null;

with stdenv.lib;

let
  libs        = [ luasocket luasec luaexpat luafilesystem luabitop lualdap luadbi ]
                ++ optional withLibevent luaevent
                ++ optional withZlib luazlib;
  getPath     = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath  = lib : getPath lib "lua";
  getLuaCPath = lib : getPath lib "so";
  luaPath     = concatStringsSep ";" (map getLuaPath  libs);
  luaCPath    = concatStringsSep ";" (map getLuaCPath libs);

  buildNumber = "267";
in

stdenv.mkDerivation rec {
  version = "0.10-1nightly${buildNumber}";
  name = "prosody-${version}";

  src = fetchurl {
    url = "https://prosody.im/nightly/0.10/build${buildNumber}/${name}.tar.gz";
    sha256 = "1208acr9bbaixzjx4ixqsfkw7aw3bc6q2441fwbx6wddz4l8p2jz";
  };

  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules/";
    rev = "131075a3bf0d";
    sha256 = "0ilq0a5pcwisgb33y3wpx652kxh1i0sq9hmd5x22jkjp6w48wap2";
  };

  buildInputs = [ lua5 luasocket luasec luaexpat luabitop lualdap luadbi libidn openssl makeWrapper ]
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
        --set LUA_PATH '${luaPath};' \
        --set LUA_CPATH '${luaCPath};'
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --set LUA_PATH '${luaPath};' \
        --set LUA_CPATH '${luaCPath};'
    '';

  outputs = [ "out" "modules" ];
  setOutputFlags = false;

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = http://www.prosody.im;
    platforms = platforms.linux;
    maintainers = with maintainers; [ flosse fpletz ];
  };
}
