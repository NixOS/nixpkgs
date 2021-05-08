{ lib, stdenv, fetchFromGitHub, ninja, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sumneko-lua-language-server";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "sumneko";
    repo = "lua-language-server";
    rev = version;
    sha256 = "sha256-7Ishq/TonJsteHBGDTNjImIwGPdeRgPS1g60d8bhTYg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    makeWrapper
  ];

  preBuild = ''
    cd 3rd/luamake
  '';

  ninjaFlags = [
    "-fninja/linux.ninja"
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
  };
}
