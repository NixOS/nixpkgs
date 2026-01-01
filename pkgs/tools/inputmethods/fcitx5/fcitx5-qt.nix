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
}:
let
  majorVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation rec {
  pname = "fcitx5-qt${majorVersion}";
<<<<<<< HEAD
  version = "5.1.12";
=======
  version = "5.1.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-qt";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Nrt49TltV3Us93MWUX4tBs0576jEC1kRX+T9IddVgZk=";
=======
    hash = "sha256-Nr8WnEm6z16NrXxuGEP4uQ6mxe8sUYtOxVgWMmFrWVE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

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

<<<<<<< HEAD
  meta = {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with lib.licenses; [
      lgpl21Plus
      bsd3
    ];
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with licenses; [
      lgpl21Plus
      bsd3
    ];
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
