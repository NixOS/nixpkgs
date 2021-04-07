{ lib, stdenv, fetchFromGitHub
, cmake, llvmPackages, rapidjson, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "ccls";
  version = "0.20201219";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = version;
    sha256 = "sha256-qCZYSzUh5WBQxMX6LtWRBz0VWnZVNR4v06aH9bJIb1o=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = with llvmPackages; [ clang-unwrapped llvm rapidjson ];

  cmakeFlags = [ "-DCCLS_VERSION=${version}" ];

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="-fvisibility=hidden -fno-rtti")
  '';

  shell = runtimeShell;
  postFixup = ''
    # We need to tell ccls where to find the standard library headers.

    standard_library_includes="\\\"-isystem\\\", \\\"${lib.getDev stdenv.cc.libc}/include\\\""
    standard_library_includes+=", \\\"-isystem\\\", \\\"${llvmPackages.libcxx}/include/c++/v1\\\""
    export standard_library_includes

    wrapped=".ccls-wrapped"
    export wrapped

    mv $out/bin/ccls $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/ccls
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  meta = with lib; {
    description = "A c/c++ language server powered by clang";
    homepage    = "https://github.com/MaskRay/ccls";
    license     = licenses.asl20;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mic92 tobim ];
  };
}
