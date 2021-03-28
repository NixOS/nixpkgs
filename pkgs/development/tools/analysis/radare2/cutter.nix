{ fetchFromGitHub, lib, mkDerivation
# nativeBuildInputs
, qmake, pkg-config
# Qt
, qtbase, qtsvg, qtwebengine
# buildInputs
, r2-for-cutter
, python3
, wrapQtAppsHook }:

mkDerivation rec {
  pname = "radare2-cutter";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "0ljj3j3apbbw628n2nyrxpbnclixx20bqjxm0xwggqzz9vywsar0";
  };

  postUnpack = "export sourceRoot=$sourceRoot/src";

  # Remove this "very helpful" helper file intended for discovering r2,
  # as it's a doozy of harddcoded paths and unexpected behavior.
  # Happily Nix has everything all set so we don't need it,
  # other than as basis for the qmakeFlags set below.
  postPatch = ''
    substituteInPlace Cutter.pro \
      --replace "include(lib_radare2.pri)" ""
  '';

  nativeBuildInputs = [ qmake pkg-config python3 wrapQtAppsHook ];
  propagatedBuildInputs = [ python3.pkgs.pyside2 ];
  buildInputs = [ qtbase qtsvg qtwebengine r2-for-cutter python3 ];

  qmakeFlags = with python3.pkgs; [
    "CONFIG+=link_pkg-config"
    "PKGCONFIG+=r_core"
    # Leaving this enabled doesn't break build but generates errors
    # at runtime (to console) about being unable to load needed bits.
    # Disable until can be looked at.
    "CUTTER_ENABLE_JUPYTER=false"
    # Enable support for Python plugins
    "CUTTER_ENABLE_PYTHON=true"
    "CUTTER_ENABLE_PYTHON_BINDINGS=true"
    "SHIBOKEN_EXTRA_OPTIONS+=-I${r2-for-cutter}/include/libr"
  ];

  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS $(pkg-config --libs python3-embed)"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A Qt and C++ GUI for radare2 reverse engineering framework";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
