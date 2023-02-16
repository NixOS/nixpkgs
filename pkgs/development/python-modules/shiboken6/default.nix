{ lib
, fetchurl
, llvmPackages
, python
, qt6
, cmake
, stdenv
, libxcrypt
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "shiboken6";

  version = "6.4.2";

  src = fetchurl {
    # https://download.qt.io/official_releases/QtForPython/shiboken6/
    url = "https://download.qt.io/official_releases/QtForPython/shiboken6/PySide6-${version}-src/pyside-setup-opensource-src-${version}.tar.xz";
    sha256 = "sha256-HsnQk2My79IpZQzxD+02yt3f96YToupuiX3k1QTBtQU=";
  };

  patches = [
    ./0001-use-llvm-config-includedir.patch
    ./0002-fix-include-qt-headers.patch
  ];

  postPatch = ''
    cd sources/${pname}
  '';

  postBuild = ''
    echo fixing RPATH of Shiboken.abi3.so
    set -x
    ldd Shiboken.abi3.so
    patchelf Shiboken.abi3.so --print-rpath | tr : $'\n'
    # fix: bad RPATH: Shiboken.abi3.so is linked to libshiboken6.abi3.so.6.4 in build tree
    # not fixed by autoPatchelfHook
    # https://bugreports.qt.io/browse/PYSIDE-2233
    patchelf Shiboken.abi3.so --shrink-rpath --allowed-rpath-prefixes $NIX_STORE
    patchelf Shiboken.abi3.so --add-rpath $out/lib
    set +x
  '';

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    python
    qt6.qtbase
  ] ++ (lib.optionals (python.pythonOlder "3.9") [
    # see similar issue: 202262
    # libxcrypt is required for crypt.h for building older python modules
    libxcrypt
  ]);

  meta = with lib; {
    description = "Generator for the pyside6 Qt bindings";
    license = with licenses; [ gpl2 lgpl21 ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ milahu ];
    # TODO test
    #broken = stdenv.isDarwin;
  };
}
