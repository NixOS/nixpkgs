{
  lib,
  stdenv,
  llvmPackages_18,
  overrideCC,
  rocm-device-libs,
  rocm-runtime,
  fetchFromGitHub,
  runCommand,
  symlinkJoin,
  rdfind,
  wrapBintoolsWith,
  emptyDirectory,
  zstd,
  zlib,
  gcc-unwrapped,
  glibc,
  replaceVars,
  libffi,
  libxml2,
  removeReferencesTo,
  fetchpatch,
  # Build compilers and stdenv suitable for profiling
  # compressed line tables (-g1 -gz) and
  # frame pointers for sampling profilers (-fno-omit-frame-pointer -momit-leaf-frame-pointer)
  # TODO: Should also apply to downstream packages which use rocmClangStdenv
  profilableStdenv ? false,
}:

let
  llvmPackagesNoBintools = llvmPackages_18.override {
    bootBintools = null;
    bootBintoolsNoLibc = null;
  };
  useLibcxx = false; # whether rocm stdenv uses libcxx (clang c++ stdlib) instead of gcc stdlibc++

  llvmStdenv = overrideCC llvmPackagesNoBintools.libcxxStdenv llvmPackagesNoBintools.clangUseLLVM;
  llvmLibstdcxxStdenv = overrideCC llvmPackagesNoBintools.stdenv (
    llvmPackagesNoBintools.libstdcxxClang.override {
      inherit (llvmPackages_18) bintools;
    }
  );
  stdenvToBuildRocmLlvm = if useLibcxx then llvmStdenv else llvmLibstdcxxStdenv;
  gcc-include = runCommand "gcc-include" { } ''
    mkdir -p $out
    ln -s ${gcc-unwrapped}/include/ $out/
    ln -s ${gcc-unwrapped}/lib/ $out/
  '';

  # A prefix for use as the GCC prefix when building rocmcxx
  disallowedRefsForToolchain = [
    stdenv.cc
    stdenv.cc.cc
    stdenv.cc.bintools
    gcc-unwrapped
    stdenvToBuildRocmLlvm
    stdenvToBuildRocmLlvm.cc
    stdenvToBuildRocmLlvm.cc.cc
  ];
  gcc-prefix =
    let
      gccPrefixPaths = [
        gcc-unwrapped
        gcc-unwrapped.lib
        glibc.dev
      ];
    in
    symlinkJoin {
      name = "gcc-prefix";
      paths = gccPrefixPaths ++ [
        glibc
      ];
      disallowedRequisites = gccPrefixPaths;
      postBuild = ''
        rm -rf $out/{bin,libexec,nix-support,lib64,share,etc}
        rm $out/lib/gcc/x86_64-unknown-linux-gnu/*/plugin/include/auto-host.h

        mkdir /build/tmpout
        mv $out/* /build/tmpout
        cp -Lr --no-preserve=mode /build/tmpout/* $out/
        set -x
        versionedIncludePath="$(echo $out/include/c++/*/)"
        mv $versionedIncludePath/* $out/include/c++/
        rm -rf $versionedIncludePath/

        find $out/lib -type f -exec ${removeReferencesTo}/bin/remove-references-to -t ${gcc-unwrapped.lib} {} +

        ln -s $out $out/x86_64-unknown-linux-gnu
      '';
    };
  version = "6.3.1";
  # major version of this should be the clang version ROCm forked from
  rocmLlvmVersion = "18.0.0-${llvmSrc.rev}";
  usefulOutputs =
    drv:
    builtins.filter (x: x != null) [
      drv
      (drv.lib or null)
      (drv.dev or null)
    ];
  listUsefulOutputs = builtins.concatMap usefulOutputs;
  llvmSrc = fetchFromGitHub {
    # Performance improvements cherry-picked on top of rocm-6.3.x
    # most importantly, amdgpu-early-alwaysinline memory usage fix
    owner = "LunNova";
    repo = "llvm-project-rocm";
    rev = "4182046534deb851753f0d962146e5176f648893";
    hash = "sha256-sPmYi1WiiAqnRnHVNba2nPUxGflBC01FWCTNLPlYF9c=";
  };
  llvmSrcFixed = llvmSrc;
  llvmMajorVersion = lib.versions.major rocmLlvmVersion;
  # An llvmPackages (pkgs/development/compilers/llvm/) built from ROCm LLVM's source tree
  # optionally using LLVM libcxx
  llvmPackagesRocm = llvmPackages_18.override (_old: {
    stdenv = stdenvToBuildRocmLlvm; # old.stdenv #llvmPackagesNoBintools.libcxxStdenv;

    # not setting gitRelease = because that causes patch selection logic to use git patches
    # ROCm LLVM is closer to 18 official
    # gitRelease = {}; officialRelease = null;
    officialRelease = { }; # Set but empty because we're overriding everything from it.
    version = rocmLlvmVersion;
    src = llvmSrcFixed;
    monorepoSrc = llvmSrcFixed;
    doCheck = false;
  });
  sysrootCompiler =
    cc: name: paths:
    let
      linked = symlinkJoin { inherit name paths; };
    in
    runCommand name
      {
        # If this is erroring, try why-depends --precise on the symlinkJoin of inputs to look for the problem
        # nix why-depends --precise .#rocmPackages.llvm.rocmcxx.linked /store/path/its/not/allowed
        disallowedRequisites = disallowedRefsForToolchain;
        passthru.linked = linked;
      }
      ''
        set -x
        mkdir -p $out/
        cp --reflink=auto -rL ${linked}/* $out/
        chmod -R +rw $out
        mkdir -p $out/usr
        ln -s $out/ $out/usr/local
        mkdir -p $out/nix-support/
        # we don't need mixed 32 bit, the presence of lib64 is used by LLVM to decide it's a multilib sysroot
        rm -rf $out/lib64
        echo 'export CC=clang' >> $out/nix-support/setup-hook
        echo 'export CXX=clang++' >> $out/nix-support/setup-hook
        mkdir -p $out/lib/clang/${llvmMajorVersion}/lib/linux/
        ln -s $out/lib/linux/libclang_rt.* $out/lib/clang/${llvmMajorVersion}/lib/linux/

        find $out -type f -exec sed -i "s|${cc.out}|$out|g" {} +
        find $out -type f -exec sed -i "s|${cc.dev}|$out|g" {} +

        # our /include now has more than clang expects, so this specific dir still needs to point to cc.dev
        # FIXME: could copy into a different subdir?
        sed -i 's|set(CLANG_INCLUDE_DIRS.*$|set(CLANG_INCLUDE_DIRS "${cc.dev}/include")|g' $out/lib/cmake/clang/ClangConfig.cmake
        ${lib.getExe rdfind} -makesymlinks true $out/ # create links *within* the sysroot to save space
      '';
  findClangNostdlibincPatch =
    x:
    (
      (lib.strings.hasSuffix "add-nostdlibinc-flag.patch" (builtins.baseNameOf x))
      || (lib.strings.hasSuffix "clang-at-least-16-LLVMgold-path.patch" (builtins.baseNameOf x))
    );
  llvmTargetsFlag = "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${
    {
      "x86_64" = "X86";
      "aarch64" = "AArch64";
    }
    .${llvmStdenv.targetPlatform.parsed.cpu.name}
      or (throw "Unsupported CPU architecture: ${llvmStdenv.targetPlatform.parsed.cpu.name}")
  }";
  # -ffat-lto-objects = emit LTO object files that are compatible with non-LTO-supporting builds too
  # FatLTO objects are a special type of fat object file that contain LTO compatible IR in addition to generated object code,
  # instead of containing object code for multiple target architectures. This allows users to defer the choice of whether to
  # use LTO or not to link-time, and has been a feature available in other compilers, like GCC, for some time.

  tablegenUsage = x: !(lib.strings.hasInfix "llvm-tblgen" x);
  addGccLtoCmakeFlags = !llvmPackagesRocm.stdenv.cc.isClang;
  llvmExtraCflags =
    "-O3 -DNDEBUG -march=skylake -mtune=znver3"
    + (lib.optionalString addGccLtoCmakeFlags " -D_GLIBCXX_USE_CXX11_ABI=0 -flto -ffat-lto-objects -flto-compression-level=19 -Wl,-flto")
    + (lib.optionalString llvmPackagesRocm.stdenv.cc.isClang " -flto=thin -ffat-lto-objects")
    + (lib.optionalString profilableStdenv " -fno-omit-frame-pointer -momit-leaf-frame-pointer -gz -g1");
in
rec {
  inherit (llvmPackagesRocm) libunwind;
  inherit (llvmPackagesRocm) libcxx;
  # Pass through original attrs for debugging where non-overridden llvm/clang is getting used
  # llvm-orig = llvmPackagesRocm.llvm; # nix why-depends --derivation .#rocmPackages.clr .#rocmPackages.llvm.llvm-orig
  # clang-orig = llvmPackagesRocm.clang; # nix why-depends --derivation .#rocmPackages.clr .#rocmPackages.llvm.clang-orig
  llvm = (llvmPackagesRocm.llvm.override { ninja = emptyDirectory; }).overrideAttrs (old: {
    dontStrip = profilableStdenv;
    nativeBuildInputs = old.nativeBuildInputs ++ [ removeReferencesTo ];
    buildInputs = old.buildInputs ++ [
      zstd
      zlib
    ];
    env.NIX_BUILD_ID_STYLE = "fast";
    postPatch = ''
      ${old.postPatch or ""}
      patchShebangs lib/OffloadArch/make_generated_offload_arch_h.sh
    '';
    LDFLAGS = "-Wl,--build-id=sha1,--icf=all,--compress-debug-sections=zlib";
    cmakeFlags =
      (builtins.filter tablegenUsage old.cmakeFlags)
      ++ [
        llvmTargetsFlag
        "-DCMAKE_BUILD_TYPE=Release"
        "-DLLVM_ENABLE_ZSTD=FORCE_ON"
        "-DLLVM_ENABLE_ZLIB=FORCE_ON"
        "-DLLVM_ENABLE_THREADS=ON"
        "-DLLVM_ENABLE_LTO=Thin"
        "-DLLVM_USE_LINKER=lld"
        (lib.cmakeBool "LLVM_ENABLE_LIBCXX" useLibcxx)
        "-DCLANG_DEFAULT_CXX_STDLIB=${if useLibcxx then "libc++" else "libstdc++"}"
      ]
      ++ lib.optionals addGccLtoCmakeFlags [
        "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
        "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
        "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
      ]
      ++ lib.optionals useLibcxx [
        "-DLLVM_ENABLE_LTO=Thin"
        "-DLLVM_USE_LINKER=lld"
        "-DLLVM_ENABLE_LIBCXX=ON"
      ];
    preConfigure = ''
      ${old.preConfigure or ""}
      cmakeFlagsArray+=(
        '-DCMAKE_C_FLAGS_RELEASE=${llvmExtraCflags}'
        '-DCMAKE_CXX_FLAGS_RELEASE=${llvmExtraCflags}'
      )
    '';
    # Ensure we don't leak refs to compiler that was used to bootstrap this LLVM
    disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
    postFixup = ''
      ${old.postFixup or ""}
      remove-references-to -t "${stdenv.cc}" "$lib/lib/libLLVMSupport.a"
      find $lib -type f -exec remove-references-to -t ${stdenv.cc.cc} {} +
      find $lib -type f -exec remove-references-to -t ${stdenvToBuildRocmLlvm.cc} {} +
      find $lib -type f -exec remove-references-to -t ${stdenv.cc.bintools} {} +
    '';
  });
  lld =
    (llvmPackagesRocm.lld.override {
      libllvm = llvm;
      ninja = emptyDirectory;
    }).overrideAttrs
      (old: {
        patches = builtins.filter (
          x: !(lib.strings.hasSuffix "more-openbsd-program-headers.patch" (builtins.baseNameOf x))
        ) old.patches;
        dontStrip = profilableStdenv;
        nativeBuildInputs = old.nativeBuildInputs ++ [
          llvmPackagesNoBintools.lld
          removeReferencesTo
        ];
        buildInputs = old.buildInputs ++ [
          zstd
          zlib
        ];
        env.NIX_BUILD_ID_STYLE = "fast";
        LDFLAGS = "-Wl,--build-id=sha1,--icf=all,--compress-debug-sections=zlib";
        cmakeFlags =
          (builtins.filter tablegenUsage old.cmakeFlags)
          ++ [
            llvmTargetsFlag
            "-DCMAKE_BUILD_TYPE=Release"
            "-DLLVM_ENABLE_ZSTD=FORCE_ON"
            "-DLLVM_ENABLE_ZLIB=FORCE_ON"
            "-DLLVM_ENABLE_THREADS=ON"
            "-DLLVM_ENABLE_LTO=Thin"
            "-DLLVM_USE_LINKER=lld"
            (lib.cmakeBool "LLVM_ENABLE_LIBCXX" useLibcxx)
            "-DCLANG_DEFAULT_CXX_STDLIB=${if useLibcxx then "libc++" else "libstdc++"}"
          ]
          ++ lib.optionals addGccLtoCmakeFlags [
            "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
            "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
            "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
          ]
          ++ lib.optionals useLibcxx [
            "-DLLVM_ENABLE_LIBCXX=ON"
          ];
        # Ensure we don't leak refs to compiler that was used to bootstrap this LLVM
        disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
        postFixup = ''
          ${old.postFixup or ""}
          find $lib -type f -exec remove-references-to -t ${stdenv.cc.cc} {} +
          find $lib -type f -exec remove-references-to -t ${stdenv.cc.bintools} {} +
        '';
        preConfigure = ''
          ${old.preConfigure or ""}
          cmakeFlagsArray+=(
            '-DCMAKE_C_FLAGS_RELEASE=${llvmExtraCflags}'
            '-DCMAKE_CXX_FLAGS_RELEASE=${llvmExtraCflags}'
          )
        '';
      });
  clang-unwrapped =
    (
      (llvmPackagesRocm.clang-unwrapped.override {
        libllvm = llvm;
        ninja = emptyDirectory;
      }).overrideAttrs
      (
        old:
        let
          filteredPatches = builtins.filter (x: !(findClangNostdlibincPatch x)) old.patches;
        in
        {
          meta.platforms = [
            "x86_64-linux"
          ];
          pname = "${old.pname}-rocm";
          patches = filteredPatches ++ [
            # Never add FHS include paths
            ./clang-bodge-ignore-systemwide-incls.diff
            # Prevents builds timing out if a single compiler invocation is very slow but
            # per-arch jobs are completing by ensuring there's terminal output
            ./clang-log-jobs.diff
            (fetchpatch {
              # [ClangOffloadBundler]: Add GetBundleIDsInFile to OffloadBundler
              sha256 = "sha256-G/mzUdFfrJ2bLJgo4+mBcR6Ox7xGhWu5X+XxT4kH2c8=";
              url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/6d296f879b0fed830c54b2a9d26240da86c8bb3a.patch";
              relative = "clang";
            })
            # FIXME: Needed due to https://github.com/NixOS/nixpkgs/issues/375431
            # Once we can switch to overrideScope this can be removed
            (replaceVars ./../../../compilers/llvm/common/clang/clang-at-least-16-LLVMgold-path.patch {
              libllvmLibdir = "${llvm.lib}/lib";
            })
          ];
          nativeBuildInputs = old.nativeBuildInputs ++ [
            llvmPackagesNoBintools.lld
            removeReferencesTo
          ];
          buildInputs = old.buildInputs ++ [
            zstd
            zlib
          ];
          dontStrip = profilableStdenv;
          LDFLAGS = "-Wl,--build-id=sha1,--icf=all,--compress-debug-sections=zlib";
          env = (old.env or { }) // {
            NIX_BUILD_ID_STYLE = "fast";
          };
          # Ensure we don't leak refs to compiler that was used to bootstrap this LLVM
          disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
          # Enable structured attrs for separateDebugInfo, because it is required with disallowedReferences set
          __structuredAttrs = true;
          requiredSystemFeatures = (old.requiredSystemFeatures or [ ]) ++ [ "big-parallel" ];
          # https://github.com/llvm/llvm-project/blob/6976deebafa8e7de993ce159aa6b82c0e7089313/clang/cmake/caches/DistributionExample-stage2.cmake#L9-L11
          cmakeFlags =
            (builtins.filter tablegenUsage old.cmakeFlags)
            ++ [
              llvmTargetsFlag
              "-DCMAKE_BUILD_TYPE=Release"
              "-DLLVM_ENABLE_ZSTD=FORCE_ON"
              "-DLLVM_ENABLE_ZLIB=FORCE_ON"
              "-DLLVM_ENABLE_THREADS=ON"
              "-DLLVM_ENABLE_LTO=Thin"
              "-DLLVM_USE_LINKER=lld"
              (lib.cmakeBool "LLVM_ENABLE_LIBCXX" useLibcxx)
              "-DCLANG_DEFAULT_CXX_STDLIB=${if useLibcxx then "libc++" else "libstdc++"}"
            ]
            ++ lib.optionals addGccLtoCmakeFlags [
              "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
              "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
              "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
            ]
            ++ lib.optionals useLibcxx [
              "-DLLVM_ENABLE_LTO=Thin"
              "-DLLVM_ENABLE_LIBCXX=ON"
              "-DLLVM_USE_LINKER=lld"
              "-DCLANG_DEFAULT_RTLIB=compiler-rt"
            ]
            ++ lib.optionals (!useLibcxx) [
              # FIXME: Config file in rocmcxx instead of GCC_INSTALL_PREFIX?
              "-DGCC_INSTALL_PREFIX=${gcc-prefix}"
            ];
          postFixup = (old.postFixup or "") + ''
            find $lib -type f -exec remove-references-to -t ${stdenvToBuildRocmLlvm.cc} {} +
            find $lib -type f -exec remove-references-to -t ${stdenv.cc} {} +
            find $lib -type f -exec remove-references-to -t ${stdenv.cc.cc} {} +
            find $lib -type f -exec remove-references-to -t ${stdenv.cc.bintools} {} +
          '';
          preConfigure = (old.preConfigure or "") + ''
            cmakeFlagsArray+=(
              '-DCMAKE_C_FLAGS_RELEASE=${llvmExtraCflags}'
              '-DCMAKE_CXX_FLAGS_RELEASE=${llvmExtraCflags}'
            )
          '';
        }
      )
    )
    // {
      libllvm = llvm;
    };
  # A clang that understands standard include searching in a GNU sysroot and will put GPU libs in include path
  # in the right order
  # and expects its libc to be in the sysroot
  rocmcxx =
    (sysrootCompiler clang-unwrapped "rocmcxx" (
      listUsefulOutputs (
        [
          clang-unwrapped
          bintools
          compiler-rt
        ]
        ++ (lib.optionals useLibcxx [
          libcxx
        ])
        ++ (lib.optionals (!useLibcxx) [
          gcc-include
          glibc
          glibc.dev
        ])
      )
    ))
    // {
      version = llvmMajorVersion;
      cc = rocmcxx;
      libllvm = llvm;
      isClang = true;
      isGNU = false;
    };
  clang-tools = llvmPackagesRocm.clang-tools.override {
    inherit clang-unwrapped clang;
  };
  compiler-rt-libc = llvmPackagesRocm.compiler-rt-libc.overrideAttrs (old: {
    patches = old.patches ++ [
      (fetchpatch {
        name = "Fix-missing-main-function-in-float16-bfloat16-support-checks.patch";
        url = "https://github.com/ROCm/llvm-project/commit/68d8b3846ab1e6550910f2a9a685690eee558af2.patch";
        hash = "sha256-Db+L1HFMWVj4CrofsGbn5lnMoCzEcU+7q12KKFb17/g=";
        relative = "compiler-rt";
      })
    ];
  });
  compiler-rt = compiler-rt-libc;
  bintools = wrapBintoolsWith {
    bintools = llvmPackagesRocm.bintools-unwrapped.override {
      inherit lld llvm;
    };
  };

  clang = rocmcxx;

  # Emulate a monolithic ROCm LLVM build to support building ROCm's in-tree LLVM projects
  rocm-merged-llvm = symlinkJoin {
    name = "rocm-llvm-merge";
    paths = [
      llvm
      llvm.dev
      lld
      lld.lib
      lld.dev
      libunwind
      libunwind.dev
      compiler-rt
      compiler-rt.dev
      rocmcxx
    ]
    ++ lib.optionals useLibcxx [
      libcxx
      libcxx.out
      libcxx.dev
    ];
    postBuild = builtins.unsafeDiscardStringContext ''
      found_files=$(find $out -name '*.cmake')
      if [ -z "$found_files" ]; then
          >&2 echo "Error: No CMake files found in $out"
          exit 1
      fi

      for target in ${clang-unwrapped.out} ${clang-unwrapped.lib} ${clang-unwrapped.dev}; do
        if grep "$target" $found_files; then
            >&2 echo "Unexpected ref to $target (clang-unwrapped) found"
            # exit 1
            # # FIXME: enable this to reduce closure size
        fi
      done
    '';
    inherit version;
    llvm-src = llvmSrc;
  };

  rocmClangStdenv = overrideCC (
    if useLibcxx then llvmPackagesRocm.libcxxStdenv else llvmPackagesRocm.stdenv
  ) clang;

  # Projects
  openmp =
    (llvmPackagesRocm.openmp.override {
      stdenv = rocmClangStdenv;
      llvm = rocm-merged-llvm;
      targetLlvm = rocm-merged-llvm;
      clang-unwrapped = clang;
    }).overrideAttrs
      (old: {
        disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ removeReferencesTo ];
        cmakeFlags =
          old.cmakeFlags
          ++ [
            "-DDEVICELIBS_ROOT=${rocm-device-libs.src}"
            # OMPD support is broken in ROCm 6.3. Haven't investigated why.
            "-DLIBOMP_OMPD_SUPPORT:BOOL=FALSE"
            "-DLIBOMP_OMPD_GDB_SUPPORT:BOOL=FALSE"
          ]
          ++ lib.optionals addGccLtoCmakeFlags [
            "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
            "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
          ];
        env.LLVM = "${rocm-merged-llvm}";
        env.LLVM_DIR = "${rocm-merged-llvm}";
        buildInputs = old.buildInputs ++ [
          rocm-device-libs
          rocm-runtime
          zlib
          zstd
          libxml2
          libffi
        ];
      });
}
