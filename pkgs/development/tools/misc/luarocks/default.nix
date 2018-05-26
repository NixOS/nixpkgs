{stdenv, fetchurl, lua, curl, makeWrapper, which, unzip}:
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
stdenv.mkDerivation {
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
	      --prefix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?.lua" \
	      --prefix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?/init.lua" \

	}
    done
  '';
  meta = {
    inherit (s) version;
    description = ''A package manager for Lua'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
