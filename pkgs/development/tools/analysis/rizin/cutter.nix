{ lib
, fetchFromGitHub
, stdenv
# for passthru.plugins
, pkgs
# nativeBuildInputs
, cmake
, pkg-config
, wrapQtAppsHook
# Qt
, qt5compat
, qtbase
, qtwayland
, qtsvg
, qttools
, qtwebengine
# buildInputs
, graphviz
, python3
, rizin
}:

let cutter = stdenv.mkDerivation rec {
  pname = "cutter";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "cutter";
    rev = "v${version}";
    hash = "sha256-TSEi1mXVvvaGo4koo3EnN/veXPUHF747g+gifnl4IDQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    python3.pkgs.pyside6
  ];

  buildInputs = [
    graphviz
    python3
    qt5compat
    qtbase
    qtsvg
    qttools
    qtwebengine
    rizin
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ];

  cmakeFlags = [
    "-DCUTTER_USE_BUNDLED_RIZIN=OFF"
    "-DCUTTER_ENABLE_PYTHON=ON"
    "-DCUTTER_ENABLE_PYTHON_BINDINGS=ON"
    "-DCUTTER_ENABLE_GRAPHVIZ=ON"
    "-DCUTTER_QT6=ON"
  ];

  preBuild = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  passthru = rec {
    plugins = rizin.plugins // {
      rz-ghidra = rizin.plugins.rz-ghidra.override {
        inherit cutter qtbase qtsvg;
        enableCutterPlugin = true;
      };
    };
    withPlugins = filter: pkgs.callPackage ./wrapper.nix {
      inherit rizin cutter;
      isCutter = true;
      plugins = filter plugins;
    };
  };

  meta = with lib; {
    description = "Free and Open Source Reverse Engineering Platform powered by rizin";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    mainProgram = "cutter";
    maintainers = with maintainers; [ mic92 dtzWill ];
    inherit (rizin.meta) platforms;
  };
}; in cutter
