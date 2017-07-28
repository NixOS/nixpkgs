{ stdenv, fetchurl, libidn, openssl, makeWrapper, fetchhg
, lua5, luasocket, luasec, luaexpat, luafilesystem, luabitop
, withLibevent ? true, luaevent ? null
, withZlib ? true, luazlib ? null
, withDBI ? true, luadbi ? null
, withExtraLibs ? [ ]
, withCommunityModules ? [ ] }:

assert withLibevent -> luaevent != null;
assert withZlib -> luazlib != null;

with stdenv.lib;

let
  libs        = [ luasocket luasec luaexpat luafilesystem luabitop ]
                ++ optional withLibevent luaevent
                ++ optional withZlib luazlib
                ++ optional withDBI luadbi
                ++ withExtraLibs;
  getPath     = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath  = lib : getPath lib "lua";
  getLuaCPath = lib : getPath lib "so";
  luaPath     = concatStringsSep ";" (map getLuaPath  libs);
  luaCPath    = concatStringsSep ";" (map getLuaCPath libs);
in

stdenv.mkDerivation rec {
  version = "0.9.12";
  name = "prosody-${version}";

  src = fetchurl {
    url = "http://prosody.im/downloads/source/${name}.tar.gz";
    sha256 = "139yxqpinajl32ryrybvilh54ddb1q6s0ajjhlcs4a0rnwia6n8s";
  };

  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "d48faff92490";
    sha256 = "0pmd96nqq7847hkxvlg8721hk47iq99w7b40hjj6srzg35h2jmwn";
  };

  buildInputs = [ lua5 makeWrapper libidn openssl ];

  configureFlags = [
    "--ostype=linux"
    "--with-lua-include=${lua5}/include"
    "--with-lua=${lua5}"
  ];

  postInstall = ''
      ${concatMapStringsSep "\n" (module: ''
        cp -r $communityModules/mod_${module} $out/lib/prosody/modules/
      '') withCommunityModules}
      wrapProgram $out/bin/prosody \
        --set LUA_PATH '${luaPath};' \
        --set LUA_CPATH '${luaCPath};'
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --set LUA_PATH '${luaPath};' \
        --set LUA_CPATH '${luaCPath};'
    '';

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = http://www.prosody.im;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
  };
}
