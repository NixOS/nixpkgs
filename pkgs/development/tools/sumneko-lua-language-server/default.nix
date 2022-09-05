{ lib, stdenv, fetchFromGitHub, ninja, makeWrapper, CoreFoundation, Foundation }:
let
  target = if stdenv.isDarwin then "macOS" else "Linux";
in
stdenv.mkDerivation rec {
  pname = "sumneko-lua-language-server";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "sumneko";
    repo = "lua-language-server";
    rev = version;
    sha256 = "sha256-K/B+THEgM6pzW+VOc8pgtH+3zpWEgocEdTsuO0APoT0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    Foundation
  ];

  preBuild = ''
    cd 3rd/luamake
  ''
  + lib.optionalString stdenv.isDarwin ''
    # Needed for the test
    export HOME=/var/empty
    # This package uses the program clang for C and C++ files. The language
    # is selected via the command line argument -std, but this do not work
    # in combination with the nixpkgs clang wrapper. Therefor we have to
    # find all c++ compiler statements and replace $cc (which expands to
    # clang) with clang++.
    sed -i compile/ninja/macos.ninja \
      -e '/c++/s,$cc,clang++,' \
      -e '/test.lua/s,= .*,= true,' \
      -e '/ldl/s,$cc,clang++,'
    sed -i scripts/compiler/gcc.lua \
      -e '/cxx_/s,$cc,clang++,'
  '';

  ninjaFlags = [
    "-fcompile/ninja/${lib.toLower target}.ninja"
  ];

  postBuild = ''
    cd ../..
    ./3rd/luamake/luamake rebuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt "$out"/share/lua-language-server/bin bin/lua-language-server
    install -m644 -t "$out"/share/lua-language-server/bin bin/*.*
    install -m644 -t "$out"/share/lua-language-server {debugger,main}.lua
    cp -r locale meta script "$out"/share/lua-language-server

    # necessary for --version to work:
    install -m644 -t "$out"/share/lua-language-server changelog.md

    makeWrapper "$out"/share/lua-language-server/bin/lua-language-server \
      $out/bin/lua-language-server \
      --add-flags "-E $out/share/lua-language-server/main.lua \
      --logpath='~/.cache/sumneko_lua/log' \
      --metapath='~/.cache/sumneko_lua/meta'"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lua Language Server coded by Lua";
    homepage = "https://github.com/sumneko/lua-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "lua-language-server";
  };
}
