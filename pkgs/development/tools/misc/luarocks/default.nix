{stdenv, fetchurl
, curl, makeWrapper, which, unzip
,lua
# for 'luarocks pack'
, zip
# some packages need to be compiled with cmake
, cmake
# to be able to bring
, toLuaModule
}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.4.4";
    name="${baseName}-${version}";
    hash="0d7rl60dwh52qh5pfsphgx5ypp7k190h9ri6qpr2yx9kvqrxyf1r";
    url="http://luarocks.org/releases/luarocks-2.4.4.tar.gz";
    sha256="0d7rl60dwh52qh5pfsphgx5ypp7k190h9ri6qpr2yx9kvqrxyf1r";
  };
  buildInputs = [
    lua curl makeWrapper which unzip
  ];
in
toLuaModule (stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preConfigure = ''
    lua -e "" || {
        luajit -e "" && {
	    export LUA_SUFFIX=jit
	    configureFlags="$configureFlags --lua-suffix=$LUA_SUFFIX"
	}
    }
    lua_inc="$(echo "${lua}/include"/*/)"
    if test -n "$lua_inc"; then
        configureFlags="$configureFlags --with-lua-include=$lua_inc"
    fi
  '';

  postInstall = ''
    sed -e "1s@.*@#! ${lua}/bin/lua$LUA_SUFFIX@" -i "$out"/bin/*
    for i in "$out"/bin/*; do
        test -L "$i" || {
	    wrapProgram "$i" \
	      --suffix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?.lua" \
	      --suffix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?/init.lua" \
	      --suffix LUA_CPATH ";" "$(echo "$out"/lib/lua/*/)?.so" \
	      --suffix LUA_CPATH ";" "$(echo "$out"/share/lua/*/)?/init.lua"

	}
    done
  '';

  propagatedBuildInputs = [ zip unzip cmake ];

  # unpack hook for src.rock files
  setupHook = ./setup-hook.sh;

  # cmake is just to compile packages wit cmake types, not luarocks itself
  dontUseCmakeConfigure = true;

  meta = with stdenv.lib; {
    inherit (s) version;
    description = ''A package manager for Lua'';
    license = licenses.mit ;
    maintainers = [maintainers.raskin];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
