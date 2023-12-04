{ mkDerivation, ...}:
mkDerivation {
  pname = "libcxx";
  path = "lib/libc++";
  extraPaths = [
    "contrib/llvm-project/libcxx"
    "contrib/libcxxrt"
  ];
  preBuild = ''
    mkdir $BSDSRCDIR/lib/libc++/filesystem
    mkdir $BSDSRCDIR/lib/libc++/ryu
  '';
}
