/* This file defines the composition for Lua packages.  It has
   been factored out of all-packages.nix because there are many of
   them.  Also, because most Nix expressions for Lua packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{ fetchurl, stdenv, lua, callPackage, unzip, zziplib, pkgconfig
, pcre, oniguruma, gnulib, tre, glibc, sqlite, openssl, expat
, glib, gobject-introspection, libevent, zlib, autoreconfHook, gnum4
, mysql, postgresql, cyrus_sasl
, fetchFromGitHub, libmpack, which, fetchpatch, writeText
, pkgs
, fetchgit
, lib
}:

let
  packages = ( self:

let
  luaAtLeast = lib.versionAtLeast lua.luaversion;
  luaOlder = lib.versionOlder lua.luaversion;
  isLua51 = (lib.versions.majorMinor lua.version) == "5.1";
  isLua52 = (lib.versions.majorMinor lua.version) == "5.2";
  isLua53 = lua.luaversion == "5.3";
  isLuaJIT = (builtins.parseDrvName lua.name).name == "luajit";

  lua-setup-hook = callPackage ../development/interpreters/lua-5/setup-hook.nix { };

  # Check whether a derivation provides a lua module.
  hasLuaModule = drv: drv ? luaModule ;

  callPackage = pkgs.newScope self;

  requiredLuaModules = drvs: with stdenv.lib; let
    modules =  filter hasLuaModule drvs;
  in unique ([lua] ++ modules ++ concatLists (catAttrs "requiredLuaModules" modules));

  # Convert derivation to a lua module.
  toLuaModule = drv:
    drv.overrideAttrs( oldAttrs: {
      # Use passthru in order to prevent rebuilds when possible.
      passthru = (oldAttrs.passthru or {})// {
        luaModule = lua;
        requiredLuaModules = requiredLuaModules drv.propagatedBuildInputs;
      };
    });


  platformString =
    if stdenv.isDarwin then "macosx"
    else if stdenv.isFreeBSD then "freebsd"
    else if stdenv.isLinux then "linux"
    else if stdenv.isSunOS then "solaris"
    else throw "unsupported platform";

  buildLuaApplication = args: buildLuarocksPackage ({namePrefix="";} // args );

  buildLuarocksPackage = with pkgs.lib; makeOverridable( callPackage ../development/interpreters/lua-5/build-lua-package.nix {
    inherit toLuaModule;
    inherit lua;
  });
in
with self; {

  getLuaPathList = majorVersion: [
     "lib/lua/${majorVersion}/?.lua" "share/lua/${majorVersion}/?.lua"
    "share/lua/${majorVersion}/?/init.lua" "lib/lua/${majorVersion}/?/init.lua"
  ];
  getLuaCPathList = majorVersion: [
     "lib/lua/${majorVersion}/?.so" "share/lua/${majorVersion}/?.so" "share/lua/${majorVersion}/?/init.so"
  ];

  # helper functions for dealing with LUA_PATH and LUA_CPATH
  getPath       = lib : type : "${lib}/lib/lua/${lua.luaversion}/?.${type};${lib}/share/lua/${lua.luaversion}/?.${type}";
  getLuaPath    = lib : getPath lib "lua";
  getLuaCPath   = lib : getPath lib "so";

  #define build lua package function
  buildLuaPackage = callPackage ../development/lua-modules/generic {
    inherit lua writeText;
  };


  inherit toLuaModule lua-setup-hook;
  inherit buildLuarocksPackage buildLuaApplication;
  inherit requiredLuaModules luaOlder luaAtLeast
    isLua51 isLua52 isLua53 isLuaJIT lua callPackage;

  # wraps programs in $out/bin with valid LUA_PATH/LUA_CPATH
  wrapLua = callPackage ../development/interpreters/lua-5/wrap-lua.nix {
    inherit lua; inherit (pkgs) makeSetupHook makeWrapper;
  };

  luarocks = callPackage ../development/tools/misc/luarocks {
    inherit lua;
  };

  luarocks-nix = callPackage ../development/tools/misc/luarocks/luarocks-nix.nix { };

  bit32 = buildLuaPackage rec {
    version = "5.3.0";
    name = "bit32-${version}";

    src = fetchFromGitHub {
      owner = "keplerproject";
      repo = "lua-compat-5.2";
      rev = "bitlib-${version}";
      sha256 = "1ipqlbvb5w394qwhm2f3w6pdrgy8v4q8sps5hh3pqz14dcqwakhj";
    };

    buildPhase = ''
      cc ${if stdenv.isDarwin then "-bundle -undefined dynamic_lookup -all_load" else "-shared"} -Ic-api lbitlib.c -o bit32.so
    '';

    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}
      install -p bit32.so $out/lib/lua/${lua.luaversion}
    '';

    meta = with stdenv.lib; {
      description = "Lua 5.2 bit manipulation library";
      homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
      license = licenses.mit;
      maintainers = with maintainers; [ lblasc ];
      platforms = platforms.unix;
    };
  };

  compat53 = buildLuaPackage rec {
    version = "0.7";
    name = "compat53-${version}";

    src = fetchFromGitHub {
      owner = "keplerproject";
      repo = "lua-compat-5.3";
      rev = "v${version}";
      sha256 = "02a14nvn7aggg1yikj9h3dcf8aqjbxlws1bfvqbpfxv9d5phnrpz";
    };

    nativeBuildInputs = [ pkgconfig ];

    postConfigure = ''
      CFLAGS+=" -shared $(pkg-config --libs ${if isLuaJIT then "luajit" else "lua"})"
    '';

    buildPhase = ''
      cc lstrlib.c $CFLAGS -o string.so
      cc ltablib.c $CFLAGS -o table.so
      cc lutf8lib.c $CFLAGS -o utf8.so
    '';

    # The hook in ../development/lua-modules/generic/default.nix
    # is strict about share vs. lib for _PATH and _CPATH.
    installPhase = ''
      install -Dt "$out/share/lua/${lua.luaversion}/compat53" compat53/*.lua
      install -Dt "$out/lib/lua/${lua.luaversion}/compat53" *.so
    '';

    meta = with stdenv.lib; {
      description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
      homepage = "https://github.com/keplerproject/lua-compat-5.3";
      license = licenses.mit;
      maintainers = with maintainers; [ vcunat ];
      platforms = platforms.all;
    };
  };

  cqueues = buildLuaPackage rec {
    name = "cqueues-${version}";
    version = "20171014";

    src = fetchurl {
      url = "https://www.25thandclement.com/~william/projects/releases/${name}.tgz";
      sha256 = "1dabhpn6r0hlln8vx9hxm34pfcm46qzgpb2apmziwg5z51fi4ksb";
    };

    preConfigure = ''export prefix=$out'';

    # https://github.com/wahern/cqueues/issues/216
    NIX_CFLAGS_COMPILE = [ "-DCQUEUES_VERSION=${version}" ];

    nativeBuildInputs = [ gnum4 ];
    buildInputs = [ openssl ];

    meta = with stdenv.lib; {
      description = "A type of event loop for Lua";
      homepage = "https://www.25thandclement.com/~william/projects/cqueues.html";
      license = licenses.mit;
      maintainers = with maintainers; [ vcunat ];
      platforms = platforms.unix;
    };
  };

  luacyrussasl = buildLuaPackage rec {
    version = "1.1.0";
    name = "lua-cyrussasl-${version}";
    src = fetchFromGitHub {
      owner = "JorjBauer";
      repo = "lua-cyrussasl";
      rev = "v${version}";
      sha256 = "14kzm3vk96k2i1m9f5zvpvq4pnzaf7s91h5g4h4x2bq1mynzw2s1";
    };

    preBuild = ''
      makeFlagsArray=(
        CFLAGS="-O2 -fPIC"
        LDFLAGS="-O -shared -fpic -lsasl2"
        LUAPATH="$out/share/lua/${lua.luaversion}"
        CPATH="$out/lib/lua/${lua.luaversion}"
      );
      mkdir -p $out/{share,lib}/lua/${lua.luaversion}
    '';

    buildInputs = [ cyrus_sasl ];

    meta = with stdenv.lib; {
      homepage = "https://github.com/JorjBauer/lua-cyrussasl";
      description = "Cyrus SASL library for Lua 5.1+";
      license = licenses.bsd3;
    };
  };

  luaexpat = buildLuaPackage rec {
    version = "1.3.0";
    name = "expat-${version}";

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

    disabled = isLua53 || isLuaJIT;

    meta = with stdenv.lib; {
      description = "SAX XML parser based on the Expat library";
      homepage = "http://matthewwild.co.uk/projects/luaexpat";
      license = licenses.mit;
      maintainers = with maintainers; [ flosse ];
      platforms = platforms.unix;
    };
  };

  luadbi = buildLuaPackage rec {
    name = "luadbi-${version}";
    version = "0.7.1";

    src = fetchFromGitHub {
      owner = "mwild1";
      repo = "luadbi";
      rev = "v${version}";
      sha256 = "01i8018zb7w2bhaqglm7cnvbiirgd95b9d07irgz3sci91p08cwp";
    };

    MYSQL_INC="-I${mysql.connector-c}/include/mysql";

    buildInputs = [ mysql.client mysql.connector-c postgresql sqlite ];

    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace Makefile \
        --replace '-shared' '-bundle -undefined dynamic_lookup -all_load'
    '';

    installFlags = [
      "LUA_CDIR=$(out)/lib/lua/${lua.luaversion}"
      "LUA_LDIR=$(out)/share/lua/${lua.luaversion}"
    ];

    installTargets = [
      "install_lua" "install_mysql" "install_psql" "install_sqlite3"
    ];

    meta = with stdenv.lib; {
      homepage = https://github.com/mwild1/luadbi;
      license = licenses.mit;
      platforms = stdenv.lib.platforms.unix;
    };
  };

  luafilesystem = buildLuaPackage rec {
    version = "1.7.0";
    name = "filesystem-${version}";

    src = fetchFromGitHub {
      owner = "keplerproject";
      repo = "luafilesystem";
      rev = "v${stdenv.lib.replaceChars ["."] ["_"] version}";
      sha256 = "0fibrasshlgpa71m9wkpjxwmylnxpcf06rpqbaa0qwvqh94nhwby";
    };

    preConfigure = ''
      substituteInPlace config --replace "CC= gcc" "";
    ''
    + stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace config \
      --replace 'LIB_OPTION= -shared' '###' \
      --replace '#LIB_OPTION= -bundle' 'LIB_OPTION= -bundle'
      substituteInPlace Makefile --replace '10.3' '10.5'
    '';

    meta = with stdenv.lib; {
      description = "Lua library complementing filesystem-related functions";
      homepage = "https://github.com/keplerproject/luafilesystem";
      license = licenses.mit;
      maintainers = with maintainers; [ flosse ];
      platforms = platforms.unix;
    };
  };

  luaossl = buildLuaPackage rec {
    name = "luaossl-${version}";
    version = "20181207";

    src = fetchurl {
      url = "https://github.com/wahern/luaossl/releases/download/rel-${version}/luaossl-rel-${version}.zip";
      sha256 = "194r6db80ksh4zh8d2k35q6vci9zbrfvkanjl280y6ij2xyhkvj7";
    };

    preConfigure = ''export prefix=$out'';

    nativeBuildInputs = [ unzip ];
    buildInputs = [ openssl ];

    meta = with stdenv.lib; {
      description = "Comprehensive binding to OpenSSL for Lua 5.1+";
      homepage = "https://www.25thandclement.com/~william/projects/luaossl.html";
      license = licenses.mit;
      maintainers = with maintainers; [ vcunat ];
      platforms = platforms.unix;
    };
  };

  luasec = buildLuaPackage rec {
    name = "sec-0.8";

    src = fetchFromGitHub {
      owner = "brunoos";
      repo = "luasec";
      rev = "lua${name}";
      sha256 = "1cgb7ihnrrfr59a2da4d3chr7lqpid98xpglmzhv3hrpg4x5sksz";
    };

    propagatedBuildInputs = [ luasocket ];
    buildInputs = [ openssl ];

    preBuild = ''
      makeFlagsArray=(
        ${platformString}
        LUAPATH="$out/share/lua/${lua.luaversion}"
        LUACPATH="$out/lib/lua/${lua.luaversion}"
        INC_PATH="-I${lua}/include"
        LIB_PATH="-L$out/lib");
    '';

    meta = with stdenv.lib; {
      description = "Lua binding for OpenSSL library to provide TLS/SSL communication";
      homepage = "https://github.com/brunoos/luasec";
      license = licenses.mit;
      maintainers = with maintainers; [ flosse ];
      platforms = platforms.unix;
    };
  };

  luasocket = buildLuaPackage rec {
    name = "socket-${version}";
    version = "3.0-rc1";

    src = fetchFromGitHub {
      owner = "diegonehab";
      repo = "luasocket";
      rev = "v${version}";
      sha256 = "1chs7z7a3i3lck4x7rz60ziwbf793gw169hpjdfca8y4yf1hzsxk";
    };

    patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/makefile \
        --replace 10.3 10.5
    '';

    preBuild = ''
      makeFlagsArray=(
        LUAV=${lua.luaversion}
        PLAT=${platformString}
        CC=''${CC}
        LD=''${CC}
        prefix=$out
      );
    '';

    doCheck = false; # fails to find itself

    installTargets = [ "install" "install-unix" ];

    meta = with stdenv.lib; {
      description = "Network support for Lua";
      homepage = "http://w3.impa.br/~diego/software/luasocket/";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = with platforms; darwin ++ linux ++ freebsd ++ illumos;
    };
  };

  luxio = buildLuaPackage rec {
    name = "luxio-${version}";
    version = "13";

    src = fetchurl {
      url = "https://git.gitano.org.uk/luxio.git/snapshot/luxio-luxio-13.tar.bz2";
      sha256 = "1hvwslc25q7k82rxk461zr1a2041nxg7sn3sw3w0y5jxf0giz2pz";
    };

    nativeBuildInputs = [ which pkgconfig ];

    postPatch = ''
      patchShebangs .
    '';

    preBuild = ''
      makeFlagsArray=(
        INST_LIBDIR="$out/lib/lua/${lua.luaversion}"
        INST_LUADIR="$out/share/lua/${lua.luaversion}"
        LUA_BINDIR="$out/bin"
        INSTALL=install
        );
    '';

    meta = with stdenv.lib; {
      description = "Lightweight UNIX I/O and POSIX binding for Lua";
      homepage = "https://www.gitano.org.uk/luxio/";
      license = licenses.mit;
      maintainers = with maintainers; [ richardipsum ];
      platforms = platforms.unix;
    };
  };


  luastdlib = buildLuaPackage rec {
    name = "stdlib-${version}";
    version = "41.2.1";

    src = fetchFromGitHub {
      owner = "lua-stdlib";
      repo = "lua-stdlib";
      rev = "release-v${version}";
      sha256 = "03wd1qvkrj50fjszb2apzdkc8d5bpfbbi9pajl0vbrlzzmmi3jlq";
    };

    nativeBuildInputs = [ autoreconfHook unzip ];

    meta = with stdenv.lib; {
      description = "General Lua libraries";
      homepage = "https://github.com/lua-stdlib/lua-stdlib";
      license = licenses.mit;
      maintainers = with maintainers; [ vyp ];
      platforms = platforms.linux;
    };
  };

  lrexlib = buildLuaPackage rec {
    name = "lrexlib-${version}";
    version = "2.8.0";

    src = fetchFromGitHub {
      owner = "rrthomas";
      repo = "lrexlib";
      rev = "rel-2-8-0";
      sha256 = "1c62ny41b1ih6iddw5qn81gr6dqwfffzdp7q6m8x09zzcdz78zhr";
    };

    buildInputs = [ luastdlib pcre luarocks oniguruma gnulib tre glibc ];

    buildPhase = let
      luaVariable = ''LUA_PATH="${luastdlib}/share/lua/${lua.luaversion}/?/init.lua;${luastdlib}/share/lua/${lua.luaversion}/?.lua"'';
      pcreVariable = "PCRE_DIR=${pcre.out} PCRE_INCDIR=${pcre.dev}/include";
      onigVariable = "ONIG_DIR=${oniguruma}";
      gnuVariable = "GNU_INCDIR=${gnulib}/lib";
      treVariable = "TRE_DIR=${tre}";
      posixVariable = "POSIX_DIR=${glibc.dev}";
    in ''
      sed -e 's@$(LUAROCKS) $(LUAROCKS_COMMAND) $$i;@$(LUAROCKS) $(LUAROCKS_COMMAND) $$i ${pcreVariable} ${onigVariable} ${gnuVariable} ${treVariable} ${posixVariable};@' -i Makefile
      ${luaVariable} make
    '';

    installPhase = ''
      mkdir -pv $out;
      cp -r luarocks/lib $out;
    '';

    meta = with stdenv.lib; {
      description = "Lua bindings of various regex library APIs";
      homepage = "https://github.com/rrthomas/lrexlib";
      license = licenses.mit;
      maintainers = with maintainers; [ vyp ];
      platforms = platforms.linux;
    };
  };

  luasqlite3 = buildLuaPackage rec {
    name = "sqlite3-${version}";
    version = "2.3.0";

    src = fetchFromGitHub {
      owner = "LuaDist";
      repo = "luasql-sqlite3";
      rev = version;
      sha256 = "05k8zs8nsdmlwja3hdhckwknf7ww5cvbp3sxhk2xd1i3ij6aa10b";
    };

    disabled = isLua53;

    buildInputs = [ sqlite ];

    patches = [ ../development/lua-modules/luasql.patch ];

    meta = with stdenv.lib; {
      description = "Database connectivity for Lua";
      homepage = "https://github.com/LuaDist/luasql-sqlite3";
      license = licenses.mit;
      maintainers = with maintainers; [ vyp ];
      platforms = platforms.linux;
    };
  };

  lfs = buildLuaPackage rec {
    name = "lfs-${version}";
    version = "1.7.0.2";

    src = fetchFromGitHub {
      owner = "keplerproject";
      repo = "luafilesystem";
      rev = "v" + stdenv.lib.replaceStrings ["."] ["_"] version;
      sha256 = "0zmprgkm9zawdf9wnw0v3w6ibaj442wlc6alp39hmw610fl4vghi";
    };

    meta = with stdenv.lib; {
      description = "Portable library for filesystem operations";
      homepage = https://keplerproject.github.com/luafilesystem;
      license = licenses.mit;
      maintainers = with maintainers; [ vcunat ];
      platforms = platforms.all;
    };
  };

  lpeg = buildLuaPackage rec {
    name = "lpeg-${version}";
    version = "1.0.1";

    src = fetchurl {
      url = "http://www.inf.puc-rio.br/~roberto/lpeg/${name}.tar.gz";
      sha256 = "62d9f7a9ea3c1f215c77e0cadd8534c6ad9af0fb711c3f89188a8891c72f026b";
    };

    preBuild = ''
      makeFlagsArray=(CC=$CC);
    '';

    buildFlags = platformString;

    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}
      install -p lpeg.so $out/lib/lua/${lua.luaversion}
      install -p re.lua $out/lib/lua/${lua.luaversion}
    '';

    meta = with stdenv.lib; {
      description = "Parsing Expression Grammars For Lua";
      homepage = "http://www.inf.puc-rio.br/~roberto/lpeg/";
      license = licenses.mit;
      maintainers = with maintainers; [ vyp ];
      platforms = platforms.all;
    };
  };

  vicious = toLuaModule(stdenv.mkDerivation rec {
    name = "vicious-${version}";
    version = "2.3.1";

    src = fetchFromGitHub {
      owner = "Mic92";
      repo = "vicious";
      rev = "v${version}";
      sha256 = "1yzhjn8rsvjjsfycdc993ms6jy2j5jh7x3r2ax6g02z5n0anvnbx";
    };

    buildInputs = [ lua ];

    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}/
      cp -r . $out/lib/lua/${lua.luaversion}/vicious/
      printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/vicious.lua
    '';

    meta = with stdenv.lib; {
      description = "A modular widget library for the awesome window manager";
      homepage    = https://github.com/Mic92/vicious;
      license     = licenses.gpl2;
      maintainers = with maintainers; [ makefu mic92 ];
      platforms   = platforms.linux;
    };
  });

});
in packages
