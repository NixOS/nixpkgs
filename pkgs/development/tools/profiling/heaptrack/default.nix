{
  lib, mkDerivation, fetchFromGitHub, cmake, extra-cmake-modules,
  zlib, boost, libunwind, elfutils, sparsehash,
  qtbase, kio, kitemmodels, threadweaver, kconfigwidgets, kcoreaddons, kdiagram
}:

mkDerivation rec {
  pname = "heaptrack";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "heaptrack";
    rev = "v${version}";
    sha256 = "0vgwldl5n41r4y3pv8w29gmyln0k2w6m59zrfw9psm4hkxvivzlx";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [
    zlib boost libunwind elfutils sparsehash
    qtbase kio kitemmodels threadweaver kconfigwidgets kcoreaddons kdiagram
  ];

  meta = with lib; {
    description = "Heap memory profiler for Linux";
    homepage = https://github.com/KDE/heaptrack;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
