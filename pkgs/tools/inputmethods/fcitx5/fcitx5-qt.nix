{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  fcitx5,
  gettext,
  qtbase,
  qtwayland,
  wrapQtAppsHook,
  wayland,
}:
let
  majorVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-qt${majorVersion}";
  version = "5.1.16";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-qt";
    tag = finalAttrs.version;
    hash = "sha256-UJxO+1F9fj6dZKyex680W1fHh+azoQGQAsLPSEQ8dHI=";
  };

  postPatch = ''
    substituteInPlace qt${majorVersion}/platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QT${majorVersion}PLUGINDIR}" $out/${qtbase.qtPluginPrefix}
  '';

  __structuredAttrs = true;
  strictDeps = true;
  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DENABLE_QT4=OFF"
    "-DENABLE_QT5=OFF"
    "-DENABLE_QT6=OFF"
    "-DENABLE_QT${majorVersion}=ON"
  ];

  nativeBuildInputs = [
    cmake
    gettext
    wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    qtbase
    qtwayland
    fcitx5
    wayland
  ];

  meta = {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with lib.licenses; [
      lgpl21Plus
      bsd3
    ];
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
  };
})
