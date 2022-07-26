{ fetchFromGitHub, lib, mkDerivation
# nativeBuildInputs
, qmake, pkg-config, cmake
# Qt
, qtbase, qtsvg, qtwebengine, qttools
# buildInputs
, rizin
, python3
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "cutter";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "sha256-JfJQuEUeLXCjzm4d0ZNHRVazF0Bk6fVAsNvBb+okoXs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qmake pkg-config python3 wrapQtAppsHook ];
  propagatedBuildInputs = [ python3.pkgs.pyside2 ];
  buildInputs = [ qtbase qttools qtsvg qtwebengine rizin python3 ];

  cmakeFlags = [
    "-DCUTTER_USE_BUNDLED_RIZIN=OFF"
    "-DCUTTER_ENABLE_PYTHON=ON"
    "-DCUTTER_ENABLE_PYTHON_BINDINGS=ON"
  ];

  preBuild = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  meta = with lib; {
    description = "Free and Open Source Reverse Engineering Platform powered by rizin";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
