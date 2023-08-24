{ lib, stdenv, fetchFromGitHub, ninja, makeWrapper, CoreFoundation, Foundation, ditto }:

stdenv.mkDerivation rec {
  pname = "lua-language-server";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "luals";
    repo = "lua-language-server";
    rev = version;
    sha256 = "sha256-kUtiMNwJJN7ZAktSC7tZriAcTDFhvcfSwBE6KFzceMg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    Foundation
    ditto
  ];

  postPatch = ''
    # filewatch tests are failing on darwin
    # this feature is not used in lua-language-server
    sed -i /filewatch/d 3rd/bee.lua/test/test.lua

    pushd 3rd/luamake
  '' + lib.optionalString stdenv.isDarwin ''
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
    "-fcompile/ninja/${if stdenv.isDarwin then "macos" else "linux"}.ninja"
  ];

  postBuild = ''
    popd
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
      --logpath=\''${XDG_CACHE_HOME:-\$HOME/.cache}/lua-language-server/log \
      --metapath=\''${XDG_CACHE_HOME:-\$HOME/.cache}/lua-language-server/meta"

    runHook postInstall
  '';

  # some tests require local networking
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A language server that offers Lua language support";
    homepage = "https://github.com/luals/lua-language-server";
    changelog = "https://github.com/LuaLS/lua-language-server/blob/${version}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda sei40kr ];
    mainProgram = "lua-language-server";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
