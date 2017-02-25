{
  stdenv, fetchFromGitHub, cmake, ecm,
  zlib, boost162, libunwind, elfutils, sparsehash,
  qtbase, kio, kitemmodels, threadweaver, kconfigwidgets, kcoreaddons,
}:

stdenv.mkDerivation rec {
  name = "heaptrack-${version}";
  version = "2017-02-14";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "heaptrack";
    rev = "2469003b3172874e1df7e1f81c56e469b80febdb";
    sha256 = "0dqchd2r4khv9gzj4n0qjii2nqygkj5jclkji8jbvivx5qwsqznc";
  };

  nativeBuildInputs = [ cmake ecm ];
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
