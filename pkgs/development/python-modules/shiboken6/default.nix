{ lib
, fetchurl
, llvmPackages
, python
<<<<<<< HEAD
=======
, qt6
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cmake
, autoPatchelfHook
, stdenv
, libxcrypt
}:

<<<<<<< HEAD
let
  stdenv' = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
in
stdenv'.mkDerivation rec {
  pname = "shiboken6";
  version = "6.5.2";
=======
llvmPackages.stdenv.mkDerivation rec {
  pname = "shiboken6";
  version = "6.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    # https://download.qt.io/official_releases/QtForPython/shiboken6/
    url = "https://download.qt.io/official_releases/QtForPython/shiboken6/PySide6-${version}-src/pyside-setup-everywhere-src-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "sha256-kNvx0U/NQcmKfL6kS4pJUeENC3mOFUdJdW5JRmVNG6g";
  };

  sourceRoot = "pyside-setup-everywhere-src-${version}/sources/${pname}";
=======
    sha256 = "sha256-bvU7KRJyZ+OBkX5vk5nOdg7cBkTNWDGYix3nLJ1YOrQ=";
  };

  sourceRoot = "pyside-setup-everywhere-src-${lib.versions.majorMinor version}/sources/${pname}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [
    ./fix-include-qt-headers.patch
  ];

  nativeBuildInputs = [
    cmake
    python
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
<<<<<<< HEAD
    python.pkgs.qt6.qtbase
    python.pkgs.ninja
    python.pkgs.packaging
    python.pkgs.setuptools
=======
    qt6.qtbase
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  # Due to Shiboken.abi3.so being linked to libshiboken6.abi3.so.6.5 in the build tree,
  # we need to remove the build tree reference from the RPATH and then add the correct
  # directory to the RPATH. On Linux, the second part is handled by autoPatchelfHook.
  # https://bugreports.qt.io/browse/PYSIDE-2233
  preFixup = ''
    echo "fixing RPATH of Shiboken.abi3.so"
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -change {@rpath,$out/lib}/libshiboken6.abi3.6.5.dylib $out/${python.sitePackages}/shiboken6/Shiboken.abi3.so
  '' + lib.optionalString stdenv.isLinux ''
    patchelf $out/${python.sitePackages}/shiboken6/Shiboken.abi3.so --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir}
  '';

<<<<<<< HEAD
  postInstall = ''
    cd ../../..
    ${python.pythonForBuild.interpreter} setup.py egg_info --build-type=shiboken6
    cp -r shiboken6.egg-info $out/${python.sitePackages}/
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Generator for the pyside6 Qt bindings";
    license = with licenses; [ lgpl3Only gpl2Only gpl3Only ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner Enzime ];
    platforms = platforms.all;
  };
}
