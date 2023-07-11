{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, curl
, makeWrapper
, which
, unzip
, lua
, file
, nix-prefetch-git
  # for 'luarocks pack'
, zip
, nix-update-script
  # some packages need to be compiled with cmake
, cmake
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luarocks";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "luarocks";
    repo = "luarocks";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-G6HDap3pspeQtGDBq+ukN7kftDaT/CozMVdYM60F6HI=";
  };

  patches = [
    ./darwin-3.7.0.patch
    # follow standard environmental variables
    # https://github.com/luarocks/luarocks/pull/1433
    (fetchpatch {
      url = "https://github.com/luarocks/luarocks/commit/d719541577a89909185aa8de7a33cf73b7a63ac3.diff";
      sha256 = "sha256-rMnhZFqLEul0wnsxvw9nl6JXVanC5QgOZ+I/HJ0vRCM=";
    })
  ];

  postPatch = lib.optionalString stdenv.targetPlatform.isDarwin ''
    substituteInPlace src/luarocks/core/cfg.lua --subst-var-by 'darwinMinVersion' '${stdenv.targetPlatform.darwinMinVersion}'
  '';

  # Manually written ./configure does not support --build= or --host=:
  #   Error: Unknown flag: --build=x86_64-unknown-linux-gnu
  configurePlatforms = [ ];

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

  nativeBuildInputs = [ makeWrapper installShellFiles lua unzip ];

  buildInputs = [ curl which ];

  postInstall = ''
    sed -e "1s@.*@#! ${lua}/bin/lua$LUA_SUFFIX@" -i "$out"/bin/*
    substituteInPlace $out/etc/luarocks/* \
     --replace '${lua.luaOnBuild}' '${lua}'

    for i in "$out"/bin/*; do
        test -L "$i" || {
            wrapProgram "$i" \
              --suffix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?.lua" \
              --suffix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?/init.lua" \
              --suffix LUA_CPATH ";" "$(echo "$out"/lib/lua/*/)?.so" \
              --suffix LUA_CPATH ";" "$(echo "$out"/share/lua/*/)?/init.lua" \
              --suffix PATH : ${lib.makeBinPath ([ unzip ] ++
                lib.optionals (finalAttrs.pname == "luarocks-nix") [ file nix-prefetch-git ])}
        }
    done
  '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd luarocks \
      --bash <($out/bin/luarocks completion bash) \
      --fish <($out/bin/luarocks completion fish) \
      --zsh <($out/bin/luarocks completion zsh)
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

  disallowedReferences = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    lua.luaOnBuild
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A package manager for Lua";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin teto ];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "http://luarocks.org/releases/";
  };
})
