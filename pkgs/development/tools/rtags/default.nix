{ stdenv, lib, fetchgit, cmake, llvmPackages, openssl, writeScript, apple_sdk, bash, emacs }:

stdenv.mkDerivation rec {
  name = "rtags-${version}";
  version = "2.3";

  buildInputs = [ cmake llvmPackages.llvm openssl llvmPackages.clang emacs ]
    ++ lib.optional stdenv.isDarwin apple_sdk.sdk;

  preConfigure = ''
    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags) " \
           LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib" \

  '' + lib.optionalString stdenv.isDarwin ''
    export CXXFLAGS="-isysroot ${apple_sdk.sdk}/" \
           MACOSX_DEPLOYMENT_TARGET="10.9"
  '';

  src = fetchgit {
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    url = "https://github.com/andersbakken/rtags.git";
    sha256 = "05kzch88x2wiimygfli6vsr9i5hzgkybsya8qx4zvb6daip4b7yf";
  };

  meta = {
    description = "C/C++ client-server indexer based on clang";

    homepage = https://github.com/andersbakken/rtags;

    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.allBut [ "i686-linux" ];
  };
}
