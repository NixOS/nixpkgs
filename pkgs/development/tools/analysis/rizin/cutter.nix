{ fetchFromGitHub, lib, mkDerivation
# for passthru.plugins
, pkgs
# nativeBuildInputs
, qmake, pkg-config, cmake
# Qt
, qtbase, qtsvg, qtwebengine, qttools
# buildInputs
, graphviz
, rizin
, python3
, wrapQtAppsHook
}:

let cutter = mkDerivation rec {
  pname = "cutter";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "cutter";
    rev = "v${version}";
    hash = "sha256-88yIqFYIv7o6aC2YSJwWJ46fZJBnOmifv+SirsfS4tw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qmake pkg-config python3 wrapQtAppsHook ];
  propagatedBuildInputs = [ python3.pkgs.pyside2 ];
  buildInputs = [ graphviz qtbase qttools qtsvg qtwebengine rizin python3 ];

  cmakeFlags = [
    "-DCUTTER_USE_BUNDLED_RIZIN=OFF"
    "-DCUTTER_ENABLE_PYTHON=ON"
    "-DCUTTER_ENABLE_PYTHON_BINDINGS=ON"
    "-DCUTTER_ENABLE_GRAPHVIZ=ON"
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
  };
}; in cutter
