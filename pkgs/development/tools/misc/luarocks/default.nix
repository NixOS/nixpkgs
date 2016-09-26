{stdenv, fetchurl, lua, curl, makeWrapper, which, unzip}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.4.0";
    name="${baseName}-${version}";
    hash="1hwpjj4nvy8m7hfmhf52vbhmlh7r3wfjjcc589yj8dnh528iqf24";
    url="http://luarocks.org/releases/luarocks-2.4.0.tar.gz";
    sha256="1hwpjj4nvy8m7hfmhf52vbhmlh7r3wfjjcc589yj8dnh528iqf24";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
