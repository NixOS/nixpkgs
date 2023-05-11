{ lib
, fetchurl
, llvmPackages
, python
, qt6
, cmake
, autoPatchelfHook
, stdenv
, libxcrypt
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "shiboken6";
  version = "6.5.0";

  src = fetchurl {
    # https://download.qt.io/official_releases/QtForPython/shiboken6/
    url = "https://download.qt.io/official_releases/QtForPython/shiboken6/PySide6-${version}-src/pyside-setup-everywhere-src-${version}.tar.xz";
    sha256 = "sha256-bvU7KRJyZ+OBkX5vk5nOdg7cBkTNWDGYix3nLJ1YOrQ=";
  };

  sourceRoot = "pyside-setup-everywhere-src-${lib.versions.majorMinor version}/sources/${pname}";

  patches = [
    ./fix-include-qt-headers.patch
  ];

  # Due to Shiboken.abi3.so being linked to libshiboken6.abi3.so.6.5 in the build tree,
  # we need to remove the build tree reference from the RPATH and then add the correct
  # directory to the RPATH. On Linux, the second part is handled by autoPatchelfHook.
  # https://bugreports.qt.io/browse/PYSIDE-2233
  postBuild = ''
    echo "fixing RPATH of Shiboken.abi3.so"
  '' + (if stdenv.isDarwin then ''
    invalid_rpaths=$(otool -l Shiboken.abi3.so | awk '
        /^[^ ]/ {f = 0}
        $2 == "LC_RPATH" && $1 == "cmd" {f = 1}
        f && gsub(/^ *path | \(offset [0-9]+\)$/, "") == 2
    ' | grep --invert-match /nix/store)
    install_name_tool $(echo $invalid_rpaths | sed 's/^/-delete_rpath /' | tr '\n' ' ' | sed 's/ $//') Shiboken.abi3.so
    install_name_tool -add_rpath $out/lib Shiboken.abi3.so
  '' else ''
    patchelf Shiboken.abi3.so --shrink-rpath --allowed-rpath-prefixes /nix/store
  '');

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    python
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    qt6.qtbase
  ] ++ (lib.optionals (python.pythonOlder "3.9") [
    # see similar issue: 202262
    # libxcrypt is required for crypt.h for building older python modules
    libxcrypt
  ]);

  meta = with lib; {
    description = "Generator for the pyside6 Qt bindings";
    license = with licenses; [ lgpl3Only gpl2Only gpl3Only ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner Enzime ];
  };
}
