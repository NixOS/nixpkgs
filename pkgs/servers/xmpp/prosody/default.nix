{ stdenv, fetchurl, libidn, openssl, makeWrapper, fetchhg
, lua5, luasocket, luasec, luaexpat, luafilesystem, luabitop
, withLibevent ? true, luaevent ? null
, withDBI ? true, luadbi ? null
# use withExtraLibs to add additional dependencies of community modules
, withExtraLibs ? [ ]
, withOnlyInstalledCommunityModules ? [ ]
, withCommunityModules ? [ ] }:

assert withLibevent -> luaevent != null;
assert withDBI -> luadbi != null;

with stdenv.lib;

let
  libs        = [ luasocket luasec luaexpat luafilesystem luabitop ]
                ++ optional withLibevent luaevent
                ++ optional withDBI luadbi
                ++ withExtraLibs;
  getPath     = lib : type : "${lib}/lib/lua/${lua5.luaversion}/?.${type};${lib}/share/lua/${lua5.luaversion}/?.${type}";
  getLuaPath  = lib : getPath lib "lua";
  getLuaCPath = lib : getPath lib "so";
  luaPath     = concatStringsSep ";" (map getLuaPath  libs);
  luaCPath    = concatStringsSep ";" (map getLuaCPath libs);
in

stdenv.mkDerivation rec {
  version = "0.10.0";
  name = "prosody-${version}";

  src = fetchurl {
    url = "http://prosody.im/downloads/source/${name}.tar.gz";
    sha256 = "1644jy5dk46vahmh6nna36s79k8k668sbi3qamjb4q3c4m3y853l";
  };

  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "150a7bd59043";
    sha256 = "0nfx3lngcy88nd81gb7v4kh3nz1bzsm67bxgpd2lprk54diqcrz1";
  };

  buildInputs = [ lua5 makeWrapper libidn openssl ]
    ++ optional withDBI luadbi;

  configureFlags = [
    "--ostype=linux"
    "--with-lua-include=${lua5}/include"
    "--with-lua=${lua5}"
  ];

  postInstall = ''
      ${concatMapStringsSep "\n" (module: ''
        cp -r $communityModules/mod_${module} $out/lib/prosody/modules/
      '') (withCommunityModules ++ withOnlyInstalledCommunityModules)}
      wrapProgram $out/bin/prosody \
        --set LUA_PATH '${luaPath};' \
        --set LUA_CPATH '${luaCPath};'
      wrapProgram $out/bin/prosodyctl \
        --add-flags '--config "/etc/prosody/prosody.cfg.lua"' \
        --set LUA_PATH '${luaPath};' \
        --set LUA_CPATH '${luaCPath};'
    '';

  passthru.communityModules = withCommunityModules;

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = licenses.mit;
    homepage = https://prosody.im;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
