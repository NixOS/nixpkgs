{
  stdenv, fetchFromGitHub, cmake, extra-cmake-modules,
  zlib, boost, libunwind, elfutils, sparsehash, makeWrapper,
  qtbase, kio, kitemmodels, threadweaver, kconfigwidgets, kcoreaddons, kdiagram
}:

stdenv.mkDerivation rec {
  name = "heaptrack-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "heaptrack";
    rev = "v${version}";
    sha256 = "0vgwldl5n41r4y3pv8w29gmyln0k2w6m59zrfw9psm4hkxvivzlx";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [
    zlib boost libunwind elfutils sparsehash makeWrapper
    qtbase kio kitemmodels threadweaver kconfigwidgets kcoreaddons kdiagram
  ];

  postInstall = ''
    wrapProgram $out/bin/heaptrack_gui --set QT_PLUGIN_PATH ${qtbase}/${qtbase.qtPluginPrefix}
  '';

  meta = with stdenv.lib; {
    description = "Heap memory profiler for Linux";
    homepage = https://github.com/KDE/heaptrack;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
