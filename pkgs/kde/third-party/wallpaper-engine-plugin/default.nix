{
  extra-cmake-modules,
  fetchFromGitHub,
  kpackage,
  libplasma,
  lib,
  lz4,
  mkKdeDerivation,
  mpv-unwrapped,
  pkg-config,
  python3,
  qtbase,
  qtmultimedia,
  qtwebchannel,
  qtwebengine,
  qtwebsockets,
}:
mkKdeDerivation {
  pname = "wallpaper-engine-kde-plugin";
  version = "0.5.4-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-engine-kde-plugin";
    rev = "9e60b364e268814a1a778549c579ad45a9b9c7bb";
    hash = "sha256-zEpELmuK+EvQ1HIWxCSAGyJAjmGgp0yqjtNuC2DTES8=";
    fetchSubmodules = true;
  };

  patches = [ ./nix-plugin.patch ];

  extraNativeBuildInputs = [
    kpackage
    pkg-config
    (python3.withPackages (ps: with ps; [ websockets ]))
  ];

  extraBuildInputs = [
    extra-cmake-modules
    libplasma
    lz4
    mpv-unwrapped
  ];

  extraCmakeFlags = [
    (lib.cmakeFeature "QML_LIB" (
      lib.makeSearchPathOutput "out" "lib/qt-6/qml" [
        qtmultimedia
        qtwebchannel
        qtwebengine
        qtwebsockets
      ]
    ))
    (lib.cmakeFeature "Qt6_DIR" "${qtbase}/lib/cmake/Qt6")
  ];

  postInstall = ''
    cd $out/share/plasma/wallpapers/com.github.catsout.wallpaperEngineKde
    chmod +x ./contents/pyext.py
    patchShebangs --build ./contents/pyext.py
    substituteInPlace ./contents/ui/Pyext.qml \
       --replace-fail NIX_STORE_PACKAGE_PATH ${placeholder "out"}
    cd -
  '';

  meta = with lib; {
    description = "KDE wallpaper plugin integrating Wallpaper Engine";
    homepage = "https://github.com/catsout/wallpaper-engine-kde-plugin";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ macronova ];
    teams = [ ];
  };
}
