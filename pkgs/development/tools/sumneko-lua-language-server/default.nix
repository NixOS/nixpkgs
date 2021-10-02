{ lib, stdenv, fetchFromGitHub, ninja, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sumneko-lua-language-server";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "sumneko";
    repo = "lua-language-server";
    rev = version;
    sha256 = "sha256-iwmH4pbeKNkEYsaSd6I7ULSoEMwAtxOanF7vAutuW64=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    makeWrapper
  ];

  postPatch = ''
    # doesn't work on aarch64, already removed on master:
    # https://github.com/actboy168/bee.lua/commit/fd5ee552c8cff2c48eff72edc0c8db5b7bf1ee2c
    rm {3rd/luamake/,}3rd/bee.lua/test/test_platform.lua
    sed /test_platform/d -i {3rd/luamake/,}3rd/bee.lua/test/test.lua
  '';

  preBuild = ''
    cd 3rd/luamake
  '';

  ninjaFlags = [
    "-fcompile/ninja/linux.ninja"
  ];

  postBuild = ''
    cd ../..
    ./3rd/luamake/luamake rebuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/extras
    cp -r ./{locale,meta,script,*.lua} $out/extras/
    cp ./bin/Linux/{bee.so,lpeglabel.so} $out/extras
    cp ./bin/Linux/lua-language-server $out/extras/.lua-language-server-unwrapped
    makeWrapper $out/extras/.lua-language-server-unwrapped \
      $out/bin/lua-language-server \
      --add-flags "-E $out/extras/main.lua \
      --logpath='~/.cache/sumneko_lua/log' \
      --metapath='~/.cache/sumneko_lua/meta'"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lua Language Server coded by Lua ";
    homepage = "https://github.com/sumneko/lua-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ mjlbach ];
    platforms = platforms.linux;
    mainProgram = "lua-language-server";
  };
}
