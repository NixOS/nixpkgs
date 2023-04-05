{ lib, sbt, makeWrapper, boehmgc, libunwind, re2, llvmPackages, zlib }:

sbt.overrideDerivation(old: {
  nativeBuildInputs = [ makeWrapper ];

  version = "0.13.16";

  sha256 = "033nvklclvbirhpsiy28d3ccmbm26zcs9vb7j8jndsc1ln09awi2";

  postFixup = ''
    wrapProgram $out/bin/sbt \
      --set CLANG_PATH      "${llvmPackages.clang}/bin/clang" \
      --set CLANGPP_PATH    "${llvmPackages.clang}/bin/clang" \
      --set CPATH           "${lib.makeSearchPathOutput "dev" "include" [ re2 zlib boehmgc libunwind llvmPackages.libcxxabi llvmPackages.libcxx ]}/c++/v1" \
      --set LIBRARY_PATH    "${lib.makeLibraryPath [ re2 zlib boehmgc libunwind llvmPackages.libcxxabi llvmPackages.libcxx ]}" \
      --set NIX_CFLAGS_LINK "-lc++abi -lc++"
  '';
})
