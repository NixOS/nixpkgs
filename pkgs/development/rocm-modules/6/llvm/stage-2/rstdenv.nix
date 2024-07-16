{ stdenv
, overrideCC
, wrapCCWith
, llvm
, clang-unwrapped
, lld
, runtimes
, bintools
}:

overrideCC stdenv (wrapCCWith rec {
  inherit bintools;
  libcxx = runtimes;
  cc = clang-unwrapped;
  gccForLibs = stdenv.cc.cc;

  extraPackages = [
    llvm
    lld
  ];

  nixSupport.cc-cflags = [
    "-resource-dir=$out/resource-root"
    "-fuse-ld=lld"
    "-rtlib=compiler-rt"
    "-unwindlib=libunwind"
    "-Wno-unused-command-line-argument"
  ];

  extraBuildCommands = ''
    clang_version=`${cc}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
    mkdir -p $out/resource-root
    ln -s ${cc}/lib/clang/$clang_version/include $out/resource-root
    ln -s ${runtimes}/lib $out/resource-root
  '';
})
