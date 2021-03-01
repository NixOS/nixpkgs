{ lib, stdenv, fetchFromGitHub, cmake, python3, ncurses }:

stdenv.mkDerivation rec {
  pname = "libtapi";
  version = "1100.0.11"; # determined by looking at VERSION.txt

  src = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "apple-libtapi";
    rev = "664b8414f89612f2dfd35a9b679c345aa5389026";
    sha256 = "1y1yl46msabfy14z0rln333a06087bk14f5h7q1cdawn8nmvbdbr";
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

  buildFlags = [ "clangBasic" "libtapi" "tapi" ];

  installTargets = [ "install-libtapi" "install-tapi-headers" "install-tapi" ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libtapi.dylib $out/lib/libtapi.dylib
  '';

  meta = with lib; {
    description = "Replaces the Mach-O Dynamic Library Stub files in Apple's SDKs to reduce the size";
    homepage = "https://github.com/tpoechtrager/apple-libtapi";
    license = licenses.apsl20;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
