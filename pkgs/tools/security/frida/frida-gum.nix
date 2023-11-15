{ lib
, stdenv
, callPackage
, version
, src

, frida-sdk
, frida-toolchain
, meson
, ninja
, nodejs
, npmHooks
, pkg-config
, python3

, frida-gumjs-bindings ? null
}:

let
  frida-gumjs-bindings' =
    if frida-gumjs-bindings == null then
      callPackage ./frida-gumjs-bindings { }
    else
      frida-gumjs-bindings;
in

stdenv.mkDerivation {
  pname = "frida-gum";
  inherit version src;
  sourceRoot = "${src.name}/frida-gum";

  outputs = [ "out" "bin" "dev" "lib" ];

  postPatch = ''
    patchShebangs .

    mkdir -p build/bindings/gumjs
    cp ${frida-gumjs-bindings'}/package-lock.json build/bindings/gumjs
  '';

  npmRoot = "build/bindings/gumjs";
  npmDeps = frida-gumjs-bindings';

  disallowedReferences = [
    frida-gumjs-bindings'
  ];

  buildInputs = [
    frida-sdk
  ];

  nativeBuildInputs = [
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
    (lib.mesonEnable "gumjs" true)
    (lib.mesonEnable "gumpp" true)
  ];

  strictDeps = true;

  passthru = {
    frida-gumjs-bindings = frida-gumjs-bindings';
  };

  meta = with lib; {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers";
    homepage = "https://www.frida.re/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ itstarsun s1341 ];
  };
}
