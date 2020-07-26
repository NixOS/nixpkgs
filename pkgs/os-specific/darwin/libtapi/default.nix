{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation {
  name = "libtapi-1000.10.8";
  src = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "apple-libtapi";
    rev = "cd9885b97fdff92cc41e886bba4a404c42fdf71b";
    sha256 = "1a19h39a48agvnmal99n9j1fjadiqwib7hfzmn342wmgh9z3vk0g";
  };

  sourceRoot = "source/src/llvm";

  nativeBuildInputs = [ cmake python3 ];

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
    broken = stdenv.isLinux;
  };
}
