{ lib, stdenv, fetchFromGitHub, substituteAll, antlr4_9, libargs, catch2, cmake, yaml-cpp }:

let
  antlr4 = antlr4_9;
in

stdenv.mkDerivation rec {
  pname = "luaformatter";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "Koihik";
    repo = "LuaFormatter";
    rev = version;
    sha256 = "14l1f9hrp6m7z3cm5yl0njba6gfixzdirxjl8nihp9val0685vm0";
  };

  patches = [
    (substituteAll {
      src = ./fix-lib-paths.patch;
      antlr4RuntimeCpp = antlr4.runtime.cpp.dev;
      inherit libargs catch2 yaml-cpp;
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ antlr4.runtime.cpp yaml-cpp ];

  meta = with lib; {
    description = "Code formatter for Lua";
    homepage = "https://github.com/Koihik/LuaFormatter";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ figsoda SuperSandro2000 ];
    mainProgram = "lua-format";
  };
}
