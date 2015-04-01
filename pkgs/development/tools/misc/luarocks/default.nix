{stdenv, fetchurl, lua, curl, makeWrapper, which}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.2.1";
    name="${baseName}-${version}";
    hash="0mbwbx1qsarwab2apq424gw28px9h2d89v1fp9vxrrpi6dz8lgvi";
    url="http://luarocks.org/releases/luarocks-2.2.1.tar.gz";
    sha256="0mbwbx1qsarwab2apq424gw28px9h2d89v1fp9vxrrpi6dz8lgvi";
  };
  buildInputs = [
    lua curl makeWrapper which
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
