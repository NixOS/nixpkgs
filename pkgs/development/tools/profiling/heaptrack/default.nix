{
  lib,
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  extra-cmake-modules,
  makeBinaryWrapper,
  zlib,
  boost,
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

  patches = [
    # cmake: Fix C compatibility of libunwind probes
    (fetchpatch {
      url = "https://invent.kde.org/sdk/heaptrack/-/commit/c6c45f3455a652c38aefa402aece5dafa492e8ab.patch";
      hash = "sha256-eou53UUQX+S7yrz2RS95GwkAnNIZY/aaze0eAdjnbPU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    makeBinaryWrapper
  ];
  buildInputs = [
    zlib
    boost
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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
