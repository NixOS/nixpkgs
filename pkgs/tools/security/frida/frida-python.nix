{ lib
, stdenv
, buildPythonPackage
, version
, src

, autoPatchelfHook
, frida-core
, frida-gum
, frida-sdk
, frida-toolchain
, meson
, ninja
, pkg-config
, python

, typing-extensions

, coreutils
}:

let
  extension = stdenv.mkDerivation {
    pname = "frida-python-extension";
    inherit version src;
    sourceRoot = "${src.name}/frida-python";

    buildInputs = [
      frida-core
      frida-gum
      frida-sdk
    ];

    nativeBuildInputs = [
      frida-toolchain
      meson
      ninja
      pkg-config
    ];

    mesonFlags = [
      (lib.mesonOption "python_incdir" "${python}/include/python${python.pythonVersion}")
    ];

    strictDeps = true;
  };
in

buildPythonPackage {
  pname = "frida";
  inherit version src;
  sourceRoot = "${src.name}/frida-python";

  postPatch = ''
    export FRIDA_VERSION=${version}
    export FRIDA_EXTENSION=${extension}/lib/python${python.pythonVersion}/site-packages/_frida.so
  '';

  disallowedReferences = [
    extension
  ];

  propagatedBuildInputs = lib.optionals (python.pythonOlder "3.11") [
    typing-extensions
  ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  preCheck = ''
    autoPatchelf tests
    sed -i 's|/bin/cat|${coreutils}/bin/cat|' tests/data/__init__.py
  '';

  pythonImportsCheck = [
    "frida"
  ];

  strictDeps = true;

  passthru = {
    inherit extension;
  };

  meta = with lib; {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (Python bindings)";
    homepage = "https://www.frida.re/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ itstarsun s1341 ];
  };
}
