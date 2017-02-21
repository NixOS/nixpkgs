/* This file defines the composition for Lua packages.  It has
   been factored out of all-packages.nix because there are many of
   them.  Also, because most Nix expressions for Lua packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{ fetchurl, fetchzip, stdenv, lua, callPackage, unzip, zziplib, pkgconfig, libtool
, pcre, oniguruma, gnulib, tre, glibc, sqlite, openssl, expat, cairo
, perl, gtk2, python, glib, gobjectIntrospection, libevent, zlib, autoreconfHook
, fetchFromGitHub, libmpack
}:

let
  isLua51 = lua.luaversion == "5.1";
  isLua52 = lua.luaversion == "5.2";

  platformString =
    if stdenv.isDarwin then "macosx"
    else if stdenv.isFreeBSD then "freebsd"
    else if stdenv.isLinux then "linux"
    else if stdenv.isSunOS then "solaris"
    else throw "unsupported platform";

  self = _self;
  _self = with self; {
  inherit lua;
  inherit (stdenv.lib) maintainers;

  # helper functions for dealing with LUA_PATH and LUA_CPATH
  getPath       = lib : type : "${lib}/lib/lua/${lua.luaversion}/?.${type};${lib}/share/lua/${lua.luaversion}/?.${type}";
  getLuaPath    = lib : getPath lib "lua";
  getLuaCPath   = lib : getPath lib "so";

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

    buildFlags = stdenv.lib.optionalString stdenv.isDarwin "macosx";

    postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace Makefile --replace 10.4 10.5
    '';

    preBuild = ''
      makeFlagsArray=(
        ${stdenv.lib.optionalString stdenv.cc.isClang "CC=$CC"}
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

  luaevent = buildLuaPackage rec {
    version = "0.4.3";
    name = "luaevent-${version}";
    disabled = isLua52;

    src = fetchzip {
      url = "https://github.com/harningt/luaevent/archive/v${version}.tar.gz";
      sha256 = "1c1n2zqx5rwfwkqaq1jj8gvx1vswvbihj2sy445w28icz1xfhpik";
    };

    preBuild = ''
      makeFlagsArray=(
        INSTALL_DIR_LUA="$out/share/lua/${lua.luaversion}"
        INSTALL_DIR_BIN="$out/lib/lua/${lua.luaversion}"
        LUA_INC_DIR="${lua}/include"
      );
    '';

    buildInputs = [ libevent ];

    propagatedBuildInputs = [ luasocket ];

    meta = with stdenv.lib; {
      homepage = http://luaforge.net/projects/luaevent/;
      description = "Binding of libevent to Lua";
      license = licenses.mit;
      maintainers = [ maintainers.koral ];
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

    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace Makefile \
      --replace '-shared' '-bundle -undefined dynamic_lookup -all_load'
    '';

    preBuild = ''
      makeFlagsArray=(
        LUA_LDIR="$out/share/lua/${lua.luaversion}"
        LUA_INC="-I${lua}/include" LUA_CDIR="$out/lib/lua/${lua.luaversion}"
        EXPAT_INC="-I${expat.dev}/include");
    '';

    meta = {
      homepage = "http://matthewwild.co.uk/projects/luaexpat";
      platforms = stdenv.lib.platforms.unix;
      maintainers = [ stdenv.lib.maintainers.flosse ];
    };
  };

  luafilesystem = buildLuaPackage rec {
    name = "filesystem-1.6.2";
    src = fetchzip {
      url = "https://github.com/keplerproject/luafilesystem/archive/v1_6_2.tar.gz";
      sha256 = "134azkxw84xp9g5qmzjsmcva629jm7plwcmjxkdzdg05vyd7kig1";
    };
    preConfigure = "substituteInPlace config --replace 'CC= gcc' '';"
    + stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace config \
      --replace 'LIB_OPTION= -shared' '###' \
      --replace '#LIB_OPTION= -bundle' 'LIB_OPTION= -bundle'
      substituteInPlace Makefile --replace '10.3' '10.5'
    '';
    meta = {
      homepage = "https://github.com/keplerproject/luafilesystem";
      platforms = stdenv.lib.platforms.unix;
      maintainers = with maintainers; [ flosse ];
    };
  };

  luaposix = buildLuaPackage rec {
    name = "posix-${version}";
    version = "33.4.0";
    src = fetchurl {
      url = "https://github.com/luaposix/luaposix/archive/release-v${version}.tar.gz";
      sha256 = "e66262f5b7fe1c32c65f17a5ef5ffb31c4d1877019b4870a5d373e2ab6526a21";
    };
    buildInputs = [ perl ];
    meta = {
      description = "Lua bindings for POSIX API";
      homepage = "https://github.com/luaposix/luaposix";
      platforms = stdenv.lib.platforms.unix;
    };
  };

  lpty = buildLuaPackage rec {
    name = "lpty-${version}";
    version = "1.1.1";
    src = fetchurl {
      url = "http://www.tset.de/downloads/lpty-1.1-1.tar.gz";
      sha256 = "0d4ffda654dcf37dd8c99bcd100d0ee0dde7782cbd0ba9200ef8711c5cab02f1";
    };
    meta = {
      homepage = "http://www.tset.de/lpty";
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
    preBuild = ''
      makeFlagsArray=(
        INST_LIBDIR="$out/lib/lua/${lua.luaversion}"
        INST_LUADIR="$out/share/lua/${lua.luaversion}"
        LUA_BINDIR="${lua}/bin"
        LUA_INCDIR="-I${lua}/include"
        LUA_LIBDIR="-L${lua}/lib"
        );
    '';
  };

  luasec = buildLuaPackage rec {
    name = "sec-0.6";
    src = fetchFromGitHub {
      owner = "brunoos";
      repo = "luasec";
      rev = "lua${name}";
      sha256 = "0wv8l7f7na7kw5xn8mjik2wpxbizl7zvvp5s7fcwvz9kl5jdpk5b";
    };

    buildInputs = [ openssl ];

    preBuild = ''
      makeFlagsArray=(
        ${platformString}
        LUAPATH="$out/lib/lua/${lua.luaversion}"
        LUACPATH="$out/lib/lua/${lua.luaversion}"
        INC_PATH="-I${lua}/include"
        LIB_PATH="-L$out/lib");
    '';

    meta = {
      homepage = "https://github.com/brunoos/luasec";
      platforms = stdenv.lib.platforms.unix;
      maintainers = [ stdenv.lib.maintainers.flosse ];
    };
  };

  luasocket = buildLuaPackage rec {
    name = "socket-${version}";
    version = "3.0-rc1";
    src = fetchurl {
      url = "https://github.com/diegonehab/luasocket/archive/v${version}.tar.gz";
      sha256 = "0j8jx8bjicvp9khs26xjya8c495wrpb7parxfnabdqa5nnsxjrwb";
    };

    patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/makefile --replace gcc cc \
        --replace 10.3 10.5
    '';

    preBuild = ''
      makeFlagsArray=(
        LUAV=${lua.luaversion}
        PLAT=${platformString}
        prefix=$out
      );
    '';

    meta = with stdenv.lib; {
      homepage = "http://w3.impa.br/~diego/software/luasocket/";
      platforms = with platforms; darwin ++ linux ++ freebsd ++ illumos;
      maintainers = with maintainers; [ mornfall ];
    };
  };

  luazip = buildLuaPackage rec {
    name = "zip-${version}";
    version = "1.2.3";
    src = fetchzip {
      url = "https://github.com/luaforge/luazip/archive/0b8f5c958e170b1b49f05bc267bc0351ad4dfc44.zip";
      sha256 = "0zrrwhmzny5zbpx91bjbl77gzkvvdi3qhhviliggp0aj8w3faxsr";
    };
    buildInputs = [ unzip zziplib ];
    patches = [ ../development/lua-modules/zip.patch ];
    # does not currently work under lua 5.2
    disabled = isLua52;
    meta = {
      homepage = "https://github.com/luaforge/luazip";
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

  luazlib = buildLuaPackage rec {
    name = "zlib-${version}";
    version = "1.1";

    src = fetchzip {
      url = "https://github.com/brimworks/lua-zlib/archive/v${version}.tar.gz";
      sha256 = "1520lk4xpf094xn2zallqgqhs0zb4w61l49knv9y8pmhkdkxzzgy";
    };

    buildInputs = [ zlib ];

    preConfigure = "substituteInPlace Makefile --replace gcc cc --replace '-llua' ''";

    preBuild = ''
      makeFlagsArray=(
        ${platformString}
        LUAPATH="$out/share/lua/${lua.luaversion}"
        LUACPATH="$out/lib/lua/${lua.luaversion}"
        INCDIR="-I${lua}/include"
        LIBDIR="-L${lua}/lib");
    '';

    preInstall = "mkdir -p $out/lib/lua/${lua.luaversion}";

    meta = with stdenv.lib; {
      homepage = https://github.com/brimworks/lua-zlib;
      platforms = platforms.unix;
      license = licenses.mit;
      maintainers = [ maintainers.koral ];
    };
  };
      

  luastdlib = buildLuaPackage {
    name = "stdlib";
    src = fetchzip {
      url = "https://github.com/lua-stdlib/lua-stdlib/archive/release.zip";
      sha256 = "0636absdfjx8ybglwydmqxwfwmqz1c4b9s5mhxlgm4ci18lw3hms";
    };
    buildInputs = [ autoreconfHook unzip ];
    meta = {
      homepage = "https://github.com/lua-stdlib/lua-stdlib/";
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

  lrexlib = buildLuaPackage rec {
    name = "lrexlib-${version}";
    version = "2.7.2";
    src = fetchzip {
      url = "https://github.com/rrthomas/lrexlib/archive/150c251be57c4e569da0f48bf6b01fbca97179fe.zip";
      sha256 = "0acb3258681bjq61piz331r99bdff6cnkjaigq5phg3699iz5h75";
    };
    buildInputs = [ unzip luastdlib pcre luarocks oniguruma gnulib tre glibc ];

    buildPhase = let
      luaVariable = "LUA_PATH=${luastdlib}/share/lua/${lua.luaversion}/?.lua";

      pcreVariable = "PCRE_DIR=${pcre.dev}";
      onigVariable = "ONIG_DIR=${oniguruma}";
      gnuVariable = "GNU_INCDIR=${gnulib}/lib";
      treVariable = "TRE_DIR=${tre}";
      posixVariable = "POSIX_DIR=${glibc.dev}";
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
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
      broken = true;
    };
  };

  luasqlite3 = buildLuaPackage rec {
    name = "sqlite3-${version}";
    version = "2.1.1";
    src = fetchzip {
      url = "https://github.com/LuaDist/luasql-sqlite3/archive/2acdb6cb256e63e5b5a0ddd72c4639d8c0feb52d.zip";
      sha256 = "17zsa0jzciildil9k4lb0rjn9s1nj80dy16pzx9bxqyi75pjf2d4";
    };

    buildInputs = [ unzip sqlite ];

    patches = [ ../development/lua-modules/luasql.patch ];

    meta = {
      homepage = "https://github.com/LuaDist/luasql-sqlite3";
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

  lpeg = buildLuaPackage rec {
    name = "lpeg-${version}";
    version = "0.12";
    src = fetchurl {
      url = "http://www.inf.puc-rio.br/~roberto/lpeg/${name}.tar.gz";
      sha256 = "0xlbfw1w7l65a5qhnx5sfw327hkq1zcj8xmg4glfw6fj9ha4b9gg";
    };
    buildInputs = [ unzip ];

    preBuild = ''
      makeFlagsArray=(CC=$CC);
    '';

    buildFlags = platformString;

    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}
      install -p lpeg.so $out/lib/lua/${lua.luaversion}
      install -p re.lua $out/lib/lua/${lua.luaversion}
    '';

    meta = {
      homepage = "http://www.inf.puc-rio.br/~roberto/lpeg/";
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.mit;
    };
  };

  cjson = buildLuaPackage rec {
    name = "cjson-${version}";
    version = "2.1.0";
    src = fetchurl {
      url = "http://www.kyne.com.au/~mark/software/download/lua-cjson-2.1.0.tar.gz";
      sha256 = "0y67yqlsivbhshg8ma535llz90r4zag9xqza5jx0q7lkap6nkg2i";
    };
    preBuild = ''
      sed -i "s|/usr/local|$out|" Makefile
    '';
    makeFlags = [ "LUA_VERSION=${lua.luaversion}" ];
    postInstall = ''
      rm -rf $out/share/lua/${lua.luaversion}/cjson/tests
    '';
    installTargets = "install install-extra";
    meta = {
      description = "Lua C extension module for JSON support";
      license = stdenv.lib.licenses.mit;
    };
  };

  lgi = stdenv.mkDerivation rec {
    name = "lgi-${version}";
    version = "0.9.1";

    src = fetchFromGitHub {
      owner = "pavouk";
      repo = "lgi";
      rev = version;
      sha256 = "09pbapjhyc3sn0jgx747shqr9286wqfzw02h43p4pk8fv2b766b9";
    };

    meta = with stdenv.lib; {
      description = "GObject-introspection based dynamic Lua binding to GObject based libraries";
      homepage    = https://github.com/pavouk/lgi;
      license     = "custom";
      maintainers = with maintainers; [ lovek323 rasendubi ];
      platforms   = platforms.unix;
    };

    buildInputs = [ glib gobjectIntrospection lua pkgconfig ];

    makeFlags = [ "LUA_VERSION=${lua.luaversion}" ];

    preBuild = ''
      sed -i "s|/usr/local|$out|" lgi/Makefile
    '';
  };

  mpack = buildLuaPackage rec {
    name = "lua-mpack-${libmpack.version}";
    src = libmpack.src;
    sourceRoot = "libmpack-${libmpack.rev}-src/binding/lua";
    buildInputs = [ libmpack ]; #libtool lua pkgconfig ];
    dontBuild = true;
    preInstall = ''
      mkdir -p $out/lib/lua/${lua.luaversion}
    '';
    NIX_CFLAGS_COMPILE = "-Wno-error -fpic";
    installFlags = [
      "USE_SYSTEM_LUA=yes"
      "LUA_VERSION_MAJ_MIN="
      "LUA_CMOD_INSTALLDIR=$$out/lib/lua/${lua.luaversion}"
    ];
    meta = {
      description = "Simple implementation of msgpack in C Lua 5.1";
      homepage = "https://github.com/tarruda/libmpack";
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  };

  vicious = stdenv.mkDerivation rec {
    name = "vicious-${version}";
    version = "2.1.3";

    src = fetchzip {
      url    = "http://git.sysphere.org/vicious/snapshot/vicious-${version}.tar.xz";
      sha256 = "1c901siza5vpcbkgx99g1vkqiki5qgkzx2brnj4wrpbsbfzq0bcq";
    };

    meta = with stdenv.lib; {
      description = "Vicious widgets for window managers";
      homepage    = http://git.sysphere.org/vicious/;
      license     = licenses.gpl2;
      maintainers = with maintainers; [ makefu ];
      platforms   = platforms.linux;
    };

    buildInputs = [ lua ];
    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}/
      cp -r . $out/lib/lua/${lua.luaversion}/vicious/
      printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/vicious.lua
    '';
  };

}; in self
