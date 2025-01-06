{
  mkDerivation,
  include,
  libcMinimal,
  csu,
}:

mkDerivation {
  path = "lib/libgcc_eh";
  extraPaths = [
    "lib/libgcc_s"
    "lib/libcompiler_rt"
    "lib/msun"
    "lib/libc" # needs arch-specific fpmath files
    "contrib/llvm-project/compiler-rt"
    "contrib/llvm-project/libunwind"
  ];

  outputs = [
    "out"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    include
    libcMinimal
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  postBuild = ''
    mkdir $BSDSRCDIR/lib/libgcc_s/i386 $BSDSRCDIR/lib/libgcc_s/cpu_model
    make -C $BSDSRCDIR/lib/libgcc_s $makeFlags

    mkdir $BSDSRCDIR/lib/libcompiler_rt/i386 $BSDSRCDIR/lib/libcompiler_rt/cpu_model
    make -C $BSDSRCDIR/lib/libcompiler_rt $makeFlags
  '';

  postInstall = ''
    make -C $BSDSRCDIR/lib/libgcc_s $makeFlags install
    make -C $BSDSRCDIR/lib/libcompiler_rt $makeFlags install
  '';

  alwaysKeepStatic = true;
}
