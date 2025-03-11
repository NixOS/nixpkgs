{
  lib,
  mkDerivation,
}:

mkDerivation {
  path = "gnu/lib/libexecinfo";
  extraPaths = [
    "gnu/llvm/libunwind"
    "gnu/llvm/libcxx"
    "gnu/lib/libcxx"
  ];

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  meta.platforms = lib.platforms.openbsd;
}
