{ stdenv, fetchFromGitHub, makeWrapper
, cmake, llvmPackages, rapidjson }:

stdenv.mkDerivation rec {
  name    = "ccls-${version}";
  version = "0.20181225.8";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = version;
    sha256 = "05vih8wi2lzp4zqlqd18fs3va6s8p74ws8sx7vwpcc8vcsdzq5w9";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = with llvmPackages; [ clang-unwrapped llvm rapidjson ];

  cmakeFlags = [ "-DSYSTEM_CLANG=ON" ];

  shell = stdenv.shell;
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
    platforms   = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
