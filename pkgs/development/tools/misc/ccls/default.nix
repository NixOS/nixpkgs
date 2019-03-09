{ stdenv, fetchFromGitHub, makeWrapper
, cmake, llvmPackages, rapidjson, runtimeShell }:

stdenv.mkDerivation rec {
  name    = "ccls-${version}";
  version = "0.20190301";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = version;
    sha256 = "1n60mly993czq3mnb82k8yqjrbfnsnx5v5dmr8ylqif3awcsk04i";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = with llvmPackages; [ clang-unwrapped llvm rapidjson ];

  cmakeFlags = [
    "-DSYSTEM_CLANG=ON"
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.12"
    "-DCMAKE_CXX_FLAGS=-fvisibility=hidden"
  ];

  shell = runtimeShell;
  postFixup = ''
    # We need to tell ccls where to find the standard library headers.

    standard_library_includes="\\\"-isystem\\\", \\\"${stdenv.lib.getDev stdenv.cc.libc}/include\\\""
    standard_library_includes+=", \\\"-isystem\\\", \\\"${llvmPackages.libcxx}/include/c++/v1\\\""
    export standard_library_includes

    wrapped=".ccls-wrapped"
    export wrapped

    mv $out/bin/ccls $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/ccls
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  meta = with stdenv.lib; {
    description = "A c/c++ language server powered by clang";
    homepage    = https://github.com/MaskRay/ccls;
    license     = licenses.asl20;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.mic92 ];
  };
}
