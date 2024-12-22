{
  stdenv,
  wrapCCWith,
  llvm,
  lld,
  clang-unwrapped,
  bintools,
  libc,
  libunwind,
  libcxxabi,
  libcxx,
  compiler-rt,
}:

wrapCCWith rec {
  inherit libcxx bintools;

  # We do this to avoid HIP pathing problems, and mimic a monolithic install
  cc = stdenv.mkDerivation (finalAttrs: {
    inherit (clang-unwrapped) version;
    pname = "rocm-llvm-clang";
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      clang_version=`${clang-unwrapped}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
      mkdir -p $out/{bin,include/c++/v1,lib/{cmake,clang/$clang_version/{include,lib}},libexec,share}

      for path in ${llvm} ${clang-unwrapped} ${lld} ${libc} ${libunwind} ${libcxxabi} ${libcxx} ${compiler-rt}; do
        cp -as $path/* $out
        chmod +w $out/{*,include/c++/v1,lib/{clang/$clang_version/include,cmake}}
        rm -f $out/lib/libc++.so
      done

      ln -s $out/lib/* $out/lib/clang/$clang_version/lib
      ln -sf $out/include/* $out/lib/clang/$clang_version/include

      runHook postInstall
    '';

    passthru.isClang = true;
  });

  extraPackages = [
    llvm
    lld
    libc
    libunwind
    libcxxabi
    compiler-rt
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
    ln -s ${cc}/lib/clang/$clang_version/{include,lib} $out/resource-root

    # Not sure why, but hardening seems to make things break
    echo "" > $out/nix-support/add-hardening.sh

    # GPU compilation uses builtin `lld`
    substituteInPlace $out/bin/{clang,clang++} \
      --replace-fail "-MM) dontLink=1 ;;" "-MM | --cuda-device-only) dontLink=1 ;;''\n--cuda-host-only | --cuda-compile-host-device) dontLink=0 ;;"
  '';
}
