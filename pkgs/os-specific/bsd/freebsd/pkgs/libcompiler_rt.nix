{
  stdenv,
  lib,
  mkDerivation,
  include,
}:

mkDerivation {
  path = "lib/libcompiler_rt";
  extraPaths = [
    "contrib/llvm-project/compiler-rt"
  ];

  buildInputs = [
    include
  ];

  # The build system is importing source files from another directory,
  # then trying to put the objects in lib/libcompiler_rt
  # It does not create subdirectories in the lib/libcompiler_rt directory.
  preBuild = ''
    mkdir cpu_model
  ''
  + lib.optionalString stdenv.hostPlatform.isx86_64 ''
    mkdir i386
  '';

  noLibc = true;

  alwaysKeepStatic = true;
}
