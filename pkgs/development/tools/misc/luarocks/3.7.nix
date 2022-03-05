{lib, stdenv, fetchFromGitHub
, curl, makeWrapper, which, unzip
, lua
# for 'luarocks pack'
, zip
# some packages need to be compiled with cmake
, cmake
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "luarocks";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "luarocks";
    repo = "luarocks";
    rev = "v${version}";
    sha256 = "1sn2j7hv8nbdjqj1747glk9770zw8q5v8ivaxhvwbk3vl038ck9d";
  };

  patches = [ ./darwin-3.7.0.patch ];

  postPatch = lib.optionalString stdenv.targetPlatform.isDarwin ''
    substituteInPlace src/luarocks/core/cfg.lua --subst-var-by 'darwinMinVersion' '${stdenv.targetPlatform.darwinMinVersion}'
  '';

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

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [ lua curl which ];

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

    installShellCompletion --cmd luarocks --bash <($out/bin/luarocks completion bash)
    installShellCompletion --cmd luarocks --zsh <($out/bin/luarocks completion zsh)
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
    description = "A package manager for Lua";
    license = licenses.mit ;
    maintainers = with maintainers; [raskin teto];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "http://luarocks.org/releases/";
  };
}
