{ lib, stdenv, fetchFromGitHub, cmake, python3, ncurses }:

stdenv.mkDerivation {
  name = "libtapi-1000.10.8";
  src = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "apple-libtapi";
    rev = "3cb307764cc5f1856c8a23bbdf3eb49dfc6bea48";
    sha256 = "1zb10p6xkls8x7wsdwgy9c0v16z97rfkgidii9ffq5rfczgvrhjh";
  };

  sourceRoot = "source/src/llvm";

  nativeBuildInputs = [ cmake python3 ];

  # ncurses is required here to avoid a reference to bootstrap-tools, which is
  # not allowed for the stdenv.
  buildInputs = [ ncurses ];

  cmakeFlags = [ "-DLLVM_INCLUDE_TESTS=OFF" ];

  # fixes: fatal error: 'clang/Basic/Diagnostic.h' file not found
  # adapted from upstream
  # https://github.com/tpoechtrager/apple-libtapi/blob/3cb307764cc5f1856c8a23bbdf3eb49dfc6bea48/build.sh#L58-L60
  preConfigure = ''
    INCLUDE_FIX="-I $PWD/projects/clang/include"
    INCLUDE_FIX+=" -I $PWD/build/projects/clang/include"

    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="$INCLUDE_FIX")
  '';

  buildFlags = [ "clangBasic" "libtapi" ];

  installTargets = [ "install-libtapi" "install-tapi-headers" ];

  postInstall = ''
    install_name_tool -id $out/lib/libtapi.dylib $out/lib/libtapi.dylib
  '';

  meta = with lib; {
    license = licenses.apsl20;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
