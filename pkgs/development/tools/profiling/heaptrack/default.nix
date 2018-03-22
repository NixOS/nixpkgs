{
  stdenv, fetchFromGitHub, cmake, extra-cmake-modules,
  zlib, boost, libunwind, elfutils, sparsehash,
  qtbase, kio, kitemmodels, threadweaver, kconfigwidgets, kcoreaddons, kdiagram
}:

stdenv.mkDerivation rec {
  name = "heaptrack-${version}";
  version = "2018-01-28";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "heaptrack";
    rev = "a4534d52788ab9814efca1232d402b2eb319342c";
    sha256 = "00xfv51kavvcmwgfmcixx0k5vhd06gkj5q0mm8rwxiw6215xp41a";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [
    zlib boost libunwind elfutils sparsehash
    qtbase kio kitemmodels threadweaver kconfigwidgets kcoreaddons kdiagram
  ];

  meta = with stdenv.lib; {
    description = "Heap memory profiler for Linux";
    homepage = https://github.com/KDE/heaptrack;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
