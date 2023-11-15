{ lib
, stdenv
, callPackage
, version
, barebone
, compiler
, src

, frida-gum
, frida-sdk
, frida-toolchain
, meson
, ninja
, nodejs
, npmHooks
, pkg-config
, python3
}:

let
  frida-barebone-script-runtime = callPackage ./frida-barebone-script-runtime {
    src = "${src}/frida-core/src/barebone";
    hash = barebone;
  };

  frida-compiler-agent = callPackage ./frida-compiler-agent {
    src = "${src}/frida-core/src/compiler";
    hash = compiler;
  };
in

stdenv.mkDerivation {
  pname = "frida-core";
  inherit version src;
  sourceRoot = "${src.name}/frida-core";

  outputs = [ "out" "bin" "dev" "lib" ];

  patches = [
    ./no-npm-install.patch
  ];

  postPatch = ''
    patchShebangs .

    mkdir -p build/src/barebone
    cp ${frida-barebone-script-runtime}/share/frida-barebone-script-runtime/script-runtime.js build/src/barebone

    mkdir -p build/src/compiler
    cp src/compiler/package-lock.json build/src/compiler
  '';

  npmRoot = "build/src/compiler";
  npmDeps = frida-compiler-agent;

  buildInputs = [
    frida-gum
    frida-sdk
  ];

  nativeBuildInputs = [
    frida-gum.out # vapi
    frida-sdk.out # vapi
    frida-toolchain
    meson
    ninja
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    python3
  ];

  mesonFlags = [
    (lib.mesonOption "default_library" "static")
  ];

  strictDeps = true;

  passthru = {
    inherit
      frida-barebone-script-runtime
      frida-compiler-agent
      ;
  };

  meta = with lib; {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers";
    homepage = "https://www.frida.re/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ itstarsun s1341 ];
  };
}
