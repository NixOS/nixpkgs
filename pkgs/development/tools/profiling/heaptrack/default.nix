{
  lib,
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  makeBinaryWrapper,
  zlib,
  boost179,
  libunwind,
  elfutils,
  sparsehash,
  zstd,
  qtbase,
  kio,
  kitemmodels,
  threadweaver,
  kconfigwidgets,
  kcoreaddons,
  kdiagram,
}:

mkDerivation rec {
  pname = "heaptrack";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "heaptrack";
    rev = "v${version}";
    hash = "sha256-pP+s60ERnmOctYTe/vezCg0VYzziApNY0QaF3aTccZU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    makeBinaryWrapper
  ];
  buildInputs =
    [
      zlib
      boost179
      libunwind
      sparsehash
      zstd
      qtbase
      kio
      kitemmodels
      threadweaver
      kconfigwidgets
      kcoreaddons
      kdiagram
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      elfutils
    ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper \
      $out/Applications/KDE/heaptrack_gui.app/Contents/MacOS/heaptrack_gui \
      $out/bin/heaptrack_gui
  '';

  meta = with lib; {
    description = "Heap memory profiler for Linux";
    homepage = "https://github.com/KDE/heaptrack";
    license = licenses.lgpl21Plus;
    mainProgram = "heaptrack_gui";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
