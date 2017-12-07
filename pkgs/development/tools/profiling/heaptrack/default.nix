{
  stdenv, fetchFromGitHub, cmake, extra-cmake-modules,
  zlib, boost162, libunwind, elfutils, sparsehash,
  qtbase, kio, kitemmodels, threadweaver, kconfigwidgets, kcoreaddons,
}:

stdenv.mkDerivation rec {
  name = "heaptrack-${version}";
  version = "2017-10-30";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "heaptrack";
    rev = "2bf49bc4fed144e004a9cabd40580a0f0889758f";
    sha256 = "0sqxk5cc8r2vsj5k2dj9jkd1f2x2yj3mxgsp65g7ls01bgga0i4d";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [
    zlib boost162 libunwind elfutils sparsehash
    qtbase kio kitemmodels threadweaver kconfigwidgets kcoreaddons
  ];

  meta = with stdenv.lib; {
    description = "Heap memory profiler for Linux";
    homepage = https://github.com/KDE/heaptrack;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
