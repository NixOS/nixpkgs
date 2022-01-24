{
  lib, mkDerivation, fetchFromGitHub, cmake, extra-cmake-modules,
  zlib, boost, libunwind, elfutils, sparsehash, zstd,
  qtbase, kio, kitemmodels, threadweaver, kconfigwidgets, kcoreaddons, kdiagram
}:

mkDerivation rec {
  pname = "heaptrack";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "heaptrack";
    rev = "v${version}";
    sha256 = "sha256-GXwlauLspbY+h/Y75zlHPoP27pr3xVl05LuDW+WVYxU=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [
    zlib boost libunwind elfutils sparsehash zstd
    qtbase kio kitemmodels threadweaver kconfigwidgets kcoreaddons kdiagram
  ];

  meta = with lib; {
    description = "Heap memory profiler for Linux";
    homepage = "https://github.com/KDE/heaptrack";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
