{ lib, sbt, makeWrapper, boehmgc, libunwind, re2, llvmPackages, zlib }:

sbt.overrideDerivation(old: {
  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/sbt \
      --set CLANG_PATH      "${llvmPackages.clang}/bin/clang" \
      --set CLANGPP_PATH    "${llvmPackages.clang}/bin/clang" \
      --set CPATH           "${lib.makeSearchPathOutput "dev" "include" [ re2 zlib boehmgc libunwind llvmPackages.libcxxabi llvmPackages.libcxx ]}/c++/v1" \
      --set LIBRARY_PATH    "${lib.makeLibraryPath [ re2 zlib boehmgc libunwind llvmPackages.libcxxabi llvmPackages.libcxx ]}" \
      --set NIX_CFLAGS_LINK "-lc++abi -lc++"
  '';
})
