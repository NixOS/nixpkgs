/* This file defines the composition for Lua packages.  It has
   been factored out of all-packages.nix because there are many of
   them.  Also, because most Nix expressions for Lua packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{ fetchurl, stdenv, lua, callPackage, unzip, zziplib
, pcre, oniguruma, gnulib, tre, glibc, sqlite, openssl, expat
}:

let
  isLua51 = lua.luaversion == "5.1";
  isLua52 = lua.luaversion == "5.2";
  self = _self;
  _self = with self; {
  inherit (stdenv.lib) maintainers;

  #define build lua package function
  buildLuaPackage = callPackage ../development/lua-modules/generic lua;

  luarocks = callPackage ../development/tools/misc/luarocks {
    inherit lua;
  };

  luabitop = buildLuaPackage rec {
    version = "1.0.2";
    name = "bitop-${version}";
    src = fetchurl {
      url = "http://bitop.luajit.org/download/LuaBitOp-${version}.tar.gz";
      sha256 = "16fffbrgfcw40kskh2bn9q7m3gajffwd2f35rafynlnd7llwj1qj";
    };

    preBuild = ''
      makeFlagsArray=(
        INCLUDES="-I${lua}/include"
        LUA="${lua}/bin/lua");
    '';

    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}
      install -p bit.so $out/lib/lua/${lua.luaversion}
    '';

    meta = {
      homepage = "http://bitop.luajit.org";
      maintainers = with maintainers; [ flosse ];
    };
  };

  luaexpat = buildLuaPackage rec {
    version = "1.3.0";
    name = "expat-${version}";
    isLibrary = true;
    src = fetchurl {
      url = "https://matthewwild.co.uk/projects/luaexpat/luaexpat-${version}.tar.gz";
      sha256 = "1hvxqngn0wf5642i5p3vcyhg3pmp102k63s9ry4jqyyqc1wkjq6h";
    };

    buildInputs = [ expat ];

    preBuild = ''
      makeFlagsArray=(
        LUA_LDIR="$out/share/lua/${lua.luaversion}"
        LUA_INC="-I${lua}/include" LUA_CDIR="$out/lib/lua/${lua.luaversion}"
        EXPAT_INC="-I${expat}/include");
    '';

    meta = {
      homepage = "http://matthewwild.co.uk/projects/luaexpat";
      hydraPlatforms = stdenv.lib.platforms.linux;
      maintainers = [ stdenv.lib.maintainers.flosse ];
    };
  };

  luafilesystem = buildLuaPackage rec {
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

  luasec = buildLuaPackage rec {
    version = "0.5";
    name = "sec-${version}";
    src = fetchurl {
      url = "https://github.com/brunoos/luasec/archive/luasec-${version}.tar.gz";
      sha256 = "08rm12cr1gjdnbv2jpk7xykby9l292qmz2v0dfdlgb4jfj7mk034";
    };

    buildInputs = [ openssl ];

    preBuild = ''
      makeFlagsArray=(
        linux
        LUAPATH="$out/lib/lua/${lua.luaversion}"
        LUACPATH="$out/lib/lua/${lua.luaversion}"
        INC_PATH="-I${lua}/include"
        LIB_PATH="-L$out/lib");
    '';

    meta = {
      homepage = "https://github.com/brunoos/luasec";
      hydraPlatforms = stdenv.lib.platforms.linux;
      maintainers = [ stdenv.lib.maintainers.flosse ];
    };
  };

  luasocket = buildLuaPackage rec {
    name = "socket-${version}";
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

  luazip = buildLuaPackage rec {
    name = "zip-${version}";
    version = "1.2.3";
    src = fetchurl {
      url = "https://github.com/luaforge/luazip/archive/0b8f5c958e170b1b49f05bc267bc0351ad4dfc44.zip";
      sha256 = "beb9260d606fdd5304aa958d95f0d3c20be7ca0a2cff44e7b75281c138a76a50";
    };
    buildInputs = [ unzip zziplib ];
    patches = [ ../development/lua-modules/zip.patch ];
    # does not currently work under lua 5.2
    disabled = isLua52;
    meta = {
      homepage = "https://github.com/luaforge/luazip";
      hydraPlatforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

  luastdlib = buildLuaPackage {
    name = "stdlib";
    src = fetchurl {
      url = "https://github.com/lua-stdlib/lua-stdlib/archive/release.zip";
      sha256 = "1v3158g5050sdqfrqi6d2bjh0lmi1v01a6m2nwqpr527a2dqcf0c";
    };
    buildInputs = [ unzip ];
    meta = {
      homepage = "https://github.com/lua-stdlib/lua-stdlib/";
      hydraPlatforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

  lrexlib = buildLuaPackage rec {
    name = "lrexlib-${version}";
    version = "2.7.2";
    src = fetchurl {
      url = "https://github.com/rrthomas/lrexlib/archive/150c251be57c4e569da0f48bf6b01fbca97179fe.zip";
      sha256 = "0i5brqbykc2nalp8snlq1r0wmf8y2wqp6drzr2xmq5phvj8913xh";
    };
    buildInputs = [ unzip luastdlib pcre luarocks oniguruma gnulib tre glibc ];

    buildPhase = let
      luaVariable = "LUA_PATH=${luastdlib}/share/lua/${lua.luaversion}/?.lua";

      pcreVariable = "PCRE_DIR=${pcre}";
      onigVariable = "ONIG_DIR=${oniguruma}";
      gnuVariable = "GNU_INCDIR=${gnulib}/lib";
      treVariable = "TRE_DIR=${tre}";
      posixVariable = "POSIX_DIR=${glibc}";
    in ''
      sed -e 's@$(LUAROCKS) $(LUAROCKS_COMMAND) $$i;@$(LUAROCKS) $(LUAROCKS_COMMAND) $$i ${pcreVariable} ${onigVariable} ${gnuVariable} ${treVariable} ${posixVariable};@' \
          -i Makefile
      ${luaVariable} make
    '';

    installPhase = ''
      mkdir -pv $out;
      cp -r luarocks/lib $out;
    '';

    meta = {
      homepage = "https://github.com/lua-stdlib/lua-stdlib/";
      hydraPlatforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

  luasqlite3 = buildLuaPackage rec {
    name = "sqlite3-${version}";
    version = "2.1.1";
    src = fetchurl {
      url = "https://github.com/LuaDist/luasql-sqlite3/archive/2acdb6cb256e63e5b5a0ddd72c4639d8c0feb52d.zip";
      sha256 = "1yy1n1l1801j48rlf3bhxpxqfgx46ixrs8jxhhbf7x1hn1j4axlv";
    };

    buildInputs = [ unzip sqlite ];

    patches = [ ../development/lua-modules/luasql.patch ];

    meta = {
      homepage = "https://github.com/LuaDist/luasql-sqlite3";
      hydraPlatforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

}; in self
