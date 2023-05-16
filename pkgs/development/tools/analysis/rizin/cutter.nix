{ fetchFromGitHub, lib, mkDerivation
<<<<<<< HEAD
# for passthru.plugins
, pkgs
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# nativeBuildInputs
, qmake, pkg-config, cmake
# Qt
, qtbase, qtsvg, qtwebengine, qttools
# buildInputs
<<<<<<< HEAD
, graphviz
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rizin
, python3
, wrapQtAppsHook
}:

<<<<<<< HEAD
let cutter = mkDerivation rec {
  pname = "cutter";
  version = "2.3.1";
=======
mkDerivation rec {
  pname = "cutter";
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "cutter";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-OxF6lKH4nnBU8pLzaCGVl8DUIxsbWD4RMevyGRirkPM=";
=======
    hash = "sha256-TgYX7FKTi5FBlCRDskGC/OUyh5yvS0nsLUtfCCC4S1w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qmake pkg-config python3 wrapQtAppsHook ];
  propagatedBuildInputs = [ python3.pkgs.pyside2 ];
<<<<<<< HEAD
  buildInputs = [ graphviz qtbase qttools qtsvg qtwebengine rizin python3 ];
=======
  buildInputs = [ qtbase qttools qtsvg qtwebengine rizin python3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cmakeFlags = [
    "-DCUTTER_USE_BUNDLED_RIZIN=OFF"
    "-DCUTTER_ENABLE_PYTHON=ON"
    "-DCUTTER_ENABLE_PYTHON_BINDINGS=ON"
<<<<<<< HEAD
    "-DCUTTER_ENABLE_GRAPHVIZ=ON"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  preBuild = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

<<<<<<< HEAD
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

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Free and Open Source Reverse Engineering Platform powered by rizin";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
<<<<<<< HEAD
    mainProgram = "cutter";
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}; in cutter
=======
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
