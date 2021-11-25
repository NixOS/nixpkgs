{ lib, stdenv, fetchFromGitHub, ninja, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sumneko-lua-language-server";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "sumneko";
    repo = "lua-language-server";
    rev = version;
    sha256 = "sha256-lO+FUuU7uihbRLI1X9qhOvgukRGfhDeSM/JdIqr96Fk=";
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
    "-fcompile/ninja/linux.ninja"
  ];

  postBuild = ''
    cd ../..
    ./3rd/luamake/luamake rebuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt "$out"/share/lua-language-server/bin/Linux bin/Linux/lua-language-server
    install -m644 -t "$out"/share/lua-language-server/bin/Linux bin/Linux/*.*
    install -m644 -t "$out"/share/lua-language-server {debugger,main}.lua
    cp -r locale meta script "$out"/share/lua-language-server

    # necessary for --version to work:
    install -m644 -t "$out"/share/lua-language-server changelog.md

    makeWrapper "$out"/share/lua-language-server/bin/Linux/lua-language-server \
      $out/bin/lua-language-server \
      --add-flags "-E $out/share/lua-language-server/main.lua \
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
