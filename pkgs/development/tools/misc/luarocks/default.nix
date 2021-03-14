{lib, stdenv, fetchFromGitHub
, curl, makeWrapper, which, unzip
, lua
# for 'luarocks pack'
, zip
# some packages need to be compiled with cmake
, cmake
}:

stdenv.mkDerivation rec {
  pname = "luarocks";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "luarocks";
    repo = "luarocks";
    rev = "v${version}";
    sha256 = "0viiafmb8binksda79ah828q1dfnb6jsqlk7vyndl2xvx9yfn4y2";
  };

  patches = [ ./darwin-3.1.3.patch ];
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

  buildInputs = [
    lua curl makeWrapper which
  ];

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

  # unpack hook for src.rock and rockspec files
  setupHook = ./setup-hook.sh;

  # cmake is just to compile packages with "cmake" buildType, not luarocks itself
  dontUseCmakeConfigure = true;

  shellHook = ''
    export PATH="src/bin:''${PATH:-}"
    export LUA_PATH="src/?.lua;''${LUA_PATH:-}"
  '';

  meta = with lib; {
    inherit version;
    description = "A package manager for Lua";
    license = licenses.mit ;
    maintainers = with maintainers; [raskin teto];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "http://luarocks.org/releases/";
    updateWalker = true;
  };
}
