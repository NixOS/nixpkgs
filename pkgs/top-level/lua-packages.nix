/* This file defines the composition for Lua packages.  It has
  been factored out of all-packages.nix because there are many of
  them.  Also, because most Nix expressions for Lua packages are
  trivial, most are actually defined here.  I.e. there's no function
  for each package in a separate file: the call to the function would
  be almost as must code as the function itself. */

{ pkgs
, stdenv
, lib
, lua
}:


self:

let
  inherit (self) callPackage;

  buildLuaApplication = args: buildLuarocksPackage ({ namePrefix = ""; } // args);

  buildLuarocksPackage = lib.makeOverridable (callPackage ../development/interpreters/lua-5/build-lua-package.nix { });

  luaLib = callPackage ../development/lua-modules/lib.nix { };

  #define build lua package function
  buildLuaPackage = callPackage ../development/lua-modules/generic { };

  getPath = drv: pathListForVersion:
    lib.concatMapStringsSep ";" (path: "${drv}/${path}") pathListForVersion;

in
rec {

  # Dont take luaPackages from "global" pkgs scope to avoid mixing lua versions
  luaPackages = self;

  # helper functions for dealing with LUA_PATH and LUA_CPATH
  inherit luaLib;

  getLuaPath = drv: getPath drv luaLib.luaPathList;
  getLuaCPath = drv: getPath drv luaLib.luaCPathList;

  inherit (callPackage ../development/interpreters/lua-5/hooks { })
    luarocksMoveDataFolder luarocksCheckHook lua-setup-hook;

  inherit lua;
  inherit buildLuaPackage buildLuarocksPackage buildLuaApplication;
  inherit (luaLib) luaOlder luaAtLeast isLua51 isLua52 isLua53 isLuaJIT
    requiredLuaModules toLuaModule hasLuaModule;

  # wraps programs in $out/bin with valid LUA_PATH/LUA_CPATH
  wrapLua = callPackage ../development/interpreters/lua-5/wrap-lua.nix {
    inherit (pkgs.buildPackages) makeSetupHook makeWrapper;
  };

  luarocks = callPackage ../development/tools/misc/luarocks/default.nix { };

  # a fork of luarocks used to generate nix lua derivations from rockspecs
  luarocks-nix = callPackage ../development/tools/misc/luarocks/luarocks-nix.nix { };

 lua-resty-core = callPackage ({ fetchFromGitHub }: buildLuaPackage rec {
    pname = "lua-resty-core";
    version = "0.1.24";

    src = fetchFromGitHub {
      owner = "openresty";
      repo = "lua-resty-core";
      rev = "v${version}";
      sha256 = "sha256-obwyxHSot1Lb2c1dNqJor3inPou+UIBrqldbkNBCQQk=";
    };

    propagatedBuildInputs = [ lua-resty-lrucache ];

    meta = with lib; {
      description = "New FFI-based API for lua-nginx-module";
      homepage = "https://github.com/openresty/lua-resty-core";
      license = licenses.bsd3;
      maintainers = with maintainers; [ SuperSandro2000 ];
    };
  }) {};

 lua-resty-lrucache = callPackage ({ fetchFromGitHub }: buildLuaPackage rec {
    pname = "lua-resty-lrucache";
    version = "0.13";

    src = fetchFromGitHub {
      owner = "openresty";
      repo = "lua-resty-lrucache";
      rev = "v${version}";
      sha256 = "sha256-J8RNAMourxqUF8wPKd8XBhNwGC/x1KKvrVnZtYDEu4Q=";
    };

    meta = with lib; {
      description = "Lua-land LRU Cache based on LuaJIT FFI";
      homepage = "https://github.com/openresty/lua-resty-lrucache";
      license = licenses.bsd3;
      maintainers = with maintainers; [ SuperSandro2000 ];
    };
  }) {};

  luxio = callPackage ({ fetchurl, which, pkg-config }: buildLuaPackage rec {
    pname = "luxio";
    version = "13";

    src = fetchurl {
      url = "https://git.gitano.org.uk/luxio.git/snapshot/luxio-luxio-${version}.tar.bz2";
      sha256 = "1hvwslc25q7k82rxk461zr1a2041nxg7sn3sw3w0y5jxf0giz2pz";
    };

    nativeBuildInputs = [ which pkg-config ];

    postPatch = ''
      patchShebangs const-proc.lua
    '';

    preBuild = ''
      makeFlagsArray=(
        INST_LIBDIR="$out/lib/lua/${lua.luaversion}"
        INST_LUADIR="$out/share/lua/${lua.luaversion}"
        LUA_BINDIR="$out/bin"
        INSTALL=install
      );
    '';

    meta = with lib; {
      broken = stdenv.isDarwin;
      description = "Lightweight UNIX I/O and POSIX binding for Lua";
      homepage = "https://www.gitano.org.uk/luxio/";
      license = licenses.mit;
      maintainers = with maintainers; [ richardipsum ];
      platforms = platforms.unix;
    };
  }) {};

  nfd = callPackage ../development/lua-modules/nfd {
    inherit (pkgs.gnome) zenity;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };

  vicious = callPackage ({ fetchFromGitHub }: stdenv.mkDerivation rec {
    pname = "vicious";
    version = "2.5.1";

    src = fetchFromGitHub {
      owner = "vicious-widgets";
      repo = "vicious";
      rev = "v${version}";
      sha256 = "sha256-geu/g/dFAVxtY1BuJYpZoVtFS/oL66NFnqiLAnJELtI=";
    };

    buildInputs = [ lua ];

    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}/
      cp -r . $out/lib/lua/${lua.luaversion}/vicious/
      printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${lua.luaversion}/vicious.lua
    '';

    meta = with lib; {
      description = "A modular widget library for the awesome window manager";
      homepage = "https://vicious.rtfd.io";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ makefu mic92 McSinyx ];
      platforms = platforms.linux;
    };
  }) {};
}
