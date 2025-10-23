{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  fcitx5,
  gettext,
  qtbase,
  qtwayland,
  wrapQtAppsHook,
  wayland,
  fetchpatch2,
}:
let
  majorVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation rec {
  pname = "fcitx5-qt${majorVersion}";
  version = "5.1.10";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-qt";
    rev = version;
    hash = "sha256-JhmaAAJ1fevCPItVnneUCAalnDDaCjjkAl9QRhSkBk4=";
  };

  patches = [
    # TODO: remove on next release
    (fetchpatch2 {
      url = "https://github.com/fcitx/fcitx5-qt/commit/46a07a85d191fd77a1efc39c8ed43d0cd87788d2.patch?full_index=1";
      hash = "sha256-qv8Rj6YoFdMQLOB2R9LGgwCHKdhEji0Sg67W37jSIac=";
    })
    (fetchpatch2 {
      url = "https://github.com/fcitx/fcitx5-qt/commit/6ac4fdd8e90ff9c25a5219e15e83740fa38c9c71.patch?full_index=1";
      hash = "sha256-x0OdlIVmwVuq2TfBlgmfwaQszXLxwRFVf+gEU224uVA=";
    })
    (fetchpatch2 {
      url = "https://github.com/fcitx/fcitx5-qt/commit/1d07f7e8d6a7ae8651eda658f87ab0c9df08bef4.patch?full_index=1";
      hash = "sha256-22tKD7sbsTJcNqur9/Uf+XAvMvA7tzNQ9hUCMm+E+E0=";
    })
  ];

  postPatch = ''
    substituteInPlace qt${majorVersion}/platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QT${majorVersion}PLUGINDIR}" $out/${qtbase.qtPluginPrefix}
  '';

  cmakeFlags = [
    "-DENABLE_QT4=OFF"
    "-DENABLE_QT5=OFF"
    "-DENABLE_QT6=OFF"
    "-DENABLE_QT${majorVersion}=ON"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwayland
    fcitx5
    wayland
  ];

  meta = with lib; {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with licenses; [
      lgpl21Plus
      bsd3
    ];
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
