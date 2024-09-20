{
  extra-cmake-modules,
  fetchFromGitHub,
  kpackage,
  libplasma,
  lib,
  lz4,
  mkKdeDerivation,
  mpv,
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
  version = "0.5.5-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-engine-kde-plugin";
    rev = "1e604105c586c7938c5b2c19e3dc8677b2eb4bb4";
    hash = "sha256-bKGQxyS8gUi+37lODLVHphMoQwLKZt/hpSjR5MN+5GA=";
    fetchSubmodules = true;
  };

  patches = [ ./nix-plugin.patch ];

  extraNativeBuildInputs = [
    kpackage
    pkg-config
  ];

  extraBuildInputs = [
    extra-cmake-modules
    libplasma
    lz4
    mpv
  ];

  extraCmakeFlags = [
    "-DQML2_CMAKE_PATH=${
      lib.makeSearchPath "lib/qt-6/qml" [
        qtmultimedia
        qtwebchannel
        qtwebengine
        qtwebsockets
      ]
    }"
    "-DQt6_DIR=${qtbase}/lib/cmake/Qt6"
    "-DUSE_PLASMAPKG=ON"
  ];

  postInstall =
    let
      py3-ws = python3.withPackages (ps: with ps; [ websockets ]);
    in
    ''
      cd ../plugin
      PATH=${py3-ws}/bin:$PATH patchShebangs --build ./contents/pyext.py
      substituteInPlace ./contents/ui/Pyext.qml --replace-fail NIX_STORE_PACKAGE_PATH ${placeholder "out"}
      kpackagetool6 -i ./ -p $out/share/plasma/wallpapers/
    '';

  meta = with lib; {
    description = "KDE wallpaper plugin integrating Wallpaper Engine";
    homepage = "https://github.com/catsout/wallpaper-engine-kde-plugin";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ macronova ];
  };
}
