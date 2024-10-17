/*
This is a minimal/manual luarocks derivation used by `buildLuarocksPackage` to install lua packages.

As a nix user, you should use the generated lua.pkgs.luarocks that contains a luarocks manifest
which makes it recognizable to luarocks.
Generating the manifest for luarocks_bootstrap seemed too hackish, which is why we end up
with two "luarocks" derivations.

*/
{ lib
, stdenv
, fetchFromGitHub
, curl
, makeWrapper
, which
, unzip
, lua
  # for 'luarocks pack'
, zip
, nix-update-script
  # some packages need to be compiled with cmake
, cmake
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luarocks_bootstrap";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "luarocks";
    repo = "luarocks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GglygI8HP+aDFEuucOkjQ2Pgfv4+jW+og+2vL3KoZCQ=";
  };

  patches = [
    ./darwin-3.7.0.patch
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
     --replace-quiet '${lua.luaOnBuild}' '${lua}'
   ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd luarocks \
      --bash <($out/bin/luarocks completion bash) \
      --fish <($out/bin/luarocks completion fish) \
      --zsh <($out/bin/luarocks completion zsh)

    installShellCompletion --cmd luarocks-admin \
      --bash <($out/bin/luarocks-admin completion bash) \
      --fish <($out/bin/luarocks-admin completion fish) \
      --zsh <($out/bin/luarocks-admin completion zsh)
  ''
  + ''
    for i in "$out"/bin/*; do
        test -L "$i" || {
            wrapProgram "$i" \
              --suffix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?.lua" \
              --suffix LUA_PATH ";" "$(echo "$out"/share/lua/*/)?/init.lua" \
              --suffix LUA_CPATH ";" "$(echo "$out"/lib/lua/*/)?.so" \
              --suffix LUA_CPATH ";" "$(echo "$out"/share/lua/*/)?/init.lua" \
              --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedBuildInputs}
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

  disallowedReferences = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    lua.luaOnBuild
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Package manager for Lua";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin teto ];
    mainProgram = "luarocks";
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "http://luarocks.org/releases/";
  };
})
