/* This file defines the composition for Lua packages.  It has
   been factored out of all-packages.nix because there are many of
   them.  Also, because most Nix expressions for Lua packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{ fetchurl, stdenv, lua, callPackage }:

let
 isLua51 = lua.luaversion == "5.1";
 isLua52 = lua.luaversion == "5.2";
 self = _self;
 _self = with self; {
  inherit (stdenv.lib) maintainers;

  #define build lua package function
  buildLuaPackage = callPackage ../development/lua-modules/generic lua;

  filesystem = buildLuaPackage {
    name = "filesystem-1.6.2";
    src = fetchurl {
      url = "https://github.com/keplerproject/luafilesystem/archive/v1_6_2.tar.gz";
      sha256 = "1n8qdwa20ypbrny99vhkmx8q04zd2jjycdb5196xdhgvqzk10abz";
    };  
    meta = {
      homepage = "https://github.com/keplerproject/luafilesystem";
      hydraPlatforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ flosse ];
    };
  };

  sockets = buildLuaPackage rec {
    name = "sockets-${version}";
    version = "2.0.2";
    src = fetchurl {
        url = "http://files.luaforge.net/releases/luasocket/luasocket/luasocket-${version}/luasocket-${version}.tar.gz";
        sha256 = "19ichkbc4rxv00ggz8gyf29jibvc2wq9pqjik0ll326rrxswgnag";
    };
    disabled = isLua52;
    patchPhase = ''
        sed -e "s,^INSTALL_TOP_SHARE.*,INSTALL_TOP_SHARE=$out/share/lua/${lua.luaversion}," \
            -e "s,^INSTALL_TOP_LIB.*,INSTALL_TOP_LIB=$out/lib/lua/${lua.luaversion}," \
            -i config
    '';
    meta = {
      homepage = "http://w3.impa.br/~diego/software/luasocket/";
      hydraPlatforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ mornfall ];
    };
  };

}; in self
