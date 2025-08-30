{
  lib,
  stdenv,
  llvmPackages_20,
  overrideCC,
  rocm-device-libs,
  fetchFromGitHub,
  runCommand,
  symlinkJoin,
  rdfind,
  wrapBintoolsWith,
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
  # whether rocm stdenv uses libcxx (clang c++ stdlib) instead of gcc stdlibc++
  withLibcxx ? false,
}@args:

let
  llvmPackages_base = llvmPackages_20;
  llvmPackagesNoBintools = llvmPackages_base.override {
    bootBintools = null;
    bootBintoolsNoLibc = null;
  };

  llvmStdenv = overrideCC llvmPackagesNoBintools.libcxxStdenv llvmPackagesNoBintools.clangUseLLVM;
  stdenvToBuildRocmLlvm = if withLibcxx then llvmStdenv else stdenv;
  gcc-include = runCommand "gcc-include" { } ''
    mkdir -p $out
    ln -s ${gcc-unwrapped}/include/ $out/
    ln -s ${gcc-unwrapped}/lib/ $out/
  '';

  disallowedRefsForToolchain = [
    stdenv.cc
    stdenv.cc.cc
    stdenv.cc.bintools
    gcc-unwrapped
    stdenvToBuildRocmLlvm
    stdenvToBuildRocmLlvm.cc
    stdenvToBuildRocmLlvm.cc.cc
  ];
  # A prefix for use as the GCC prefix when building rocmcxx
  gcc-prefix-headers = symlinkJoin {
    name = "gcc-prefix-headers";
    paths = [
      glibc.dev
      gcc-unwrapped.out
    ];
    disallowedRequisites = [
      glibc.dev
      gcc-unwrapped.out
    ];
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
    '';
  };
  gcc-prefix = symlinkJoin {
    name = "gcc-prefix";
    paths = [
      gcc-prefix-headers
      glibc
      gcc-unwrapped.lib
    ];
    disallowedRequisites = [
      glibc.dev
      gcc-unwrapped.out
    ];
    postBuild = ''
      rm -rf $out/{bin,libexec,nix-support,lib64,share,etc}
      rm $out/lib/ld-linux-x86-64.so.2
      ln -s $out $out/x86_64-unknown-linux-gnu
    '';
  };
  version = "6.4.2";
  # major version of this should be the clang version ROCm forked from
  rocmLlvmVersion = "19.0.0-${llvmSrc.rev}";
  usefulOutputs =
    drv:
    builtins.filter (x: x != null) [
      drv
      (drv.lib or null)
      (drv.dev or null)
    ];
  listUsefulOutputs = builtins.concatMap usefulOutputs;
  llvmSrc = fetchFromGitHub {
    owner = "ROCm";
    repo = "llvm-project";
    rev = "rocm-6.4.2";
    hash = "sha256-12ftH5fMPAsbcEBmhADwW1YY/Yxo/MAK1FafKczITMg=";
  };
  llvmSrcFixed = llvmSrc;
  llvmMajorVersion = lib.versions.major rocmLlvmVersion;
  # An llvmPackages (pkgs/development/compilers/llvm/) built from ROCm LLVM's source tree
  # optionally using LLVM libcxx
  llvmPackagesRocm = llvmPackages_base.override (_old: {
    stdenv = stdenvToBuildRocmLlvm;

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
  # Removes patches which either aren't desired, or don't apply against ROCm LLVM
  removeInapplicablePatches =
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
  # LTO on for this toolchain to somewhat improve compiler performance,
  # Projects like composable_kernel build an incredible number of slow offload kernels
  commonCmakeFlags = [
    llvmTargetsFlag
    (lib.cmakeFeature "LLVM_ENABLE_ZSTD" "FORCE_ON")
    (lib.cmakeFeature "LLVM_ENABLE_ZLIB" "FORCE_ON")
    (lib.cmakeBool "LLVM_ENABLE_THREADS" true)
    (lib.cmakeFeature "CLANG_VENDOR" "nixpkgs-AMD")
    (lib.cmakeFeature "CLANG_REPOSITORY_STRING" "https://github.com/ROCm/llvm-project/tree/rocm-${version}")
    (lib.cmakeFeature "LLVM_VERSION_SUFFIX" "")
    (lib.cmakeBool "LLVM_ENABLE_LIBCXX" withLibcxx)
    (lib.cmakeFeature "CLANG_DEFAULT_CXX_STDLIB" (if withLibcxx then "libc++" else "libstdc++"))
  ]
  ++ lib.optionals withLibcxx [
    (lib.cmakeFeature "CLANG_DEFAULT_RTLIB" "compiler-rt")
  ]
  ++ lib.optionals stdenvToBuildRocmLlvm.cc.isClang [
    (lib.cmakeFeature "LLVM_ENABLE_LTO" "THIN")
    (lib.cmakeFeature "LLVM_USE_LINKER" "lld")
  ];
  tablegenUsage = x: !(lib.strings.hasInfix "llvm-tblgen" x);
  llvmExtraCflags =
    (lib.optionalString stdenvToBuildRocmLlvm.cc.isClang " -flto=thin -ffat-lto-objects")
    + (lib.optionalString profilableStdenv " -fno-omit-frame-pointer -momit-leaf-frame-pointer -gz -g1");
in
rec {
  inherit (llvmPackagesRocm) libunwind;
  inherit (llvmPackagesRocm) libcxx;
  inherit args;
  # Pass through original attrs for debugging where non-overridden llvm/clang is getting used
  # llvm-orig = llvmPackagesRocm.llvm; # nix why-depends --derivation .#rocmPackages.clr .#rocmPackages.llvm.llvm-orig
  # clang-orig = llvmPackagesRocm.clang; # nix why-depends --derivation .#rocmPackages.clr .#rocmPackages.llvm.clang-orig
  llvm = llvmPackagesRocm.llvm.overrideAttrs (old: {
    patches = old.patches ++ [
      (fetchpatch {
        # fix compile error in tools/gold/gold-plugin.cpp
        name = "gold-plugin-fix.patch";
        url = "https://github.com/llvm/llvm-project/commit/b0baa1d8bd68a2ce2f7c5f2b62333e410e9122a1.patch";
        hash = "sha256-yly93PvGIXOnFeDGZ2W+W6SyhdWFM6iwA+qOeaptrh0=";
        relative = "llvm";
      })
      (fetchpatch {
        # fix tools/llvm-exegesis/X86/latency/ failing with glibc 2.4+
        name = "exegesis-latency-glibc-fix.patch";
        sha256 = "sha256-CjKxQlYwHXTM0mVnv8k/ssg5OXuKpJxRvBZGXjrFZAg=";
        url = "https://github.com/llvm/llvm-project/commit/1e8df9e85a1ff213e5868bd822877695f27504ad.patch";
        relative = "llvm";
      })
      ./perf-increase-namestring-size.patch
      # TODO: consider reapplying "Don't include aliases in RegisterClassInfo::IgnoreCSRForAllocOrder"
      # it was reverted as it's a pessimization for non-GPU archs, but this compiler
      # is used mostly for amdgpu
    ];
    dontStrip = profilableStdenv;
    nativeBuildInputs = old.nativeBuildInputs ++ [ removeReferencesTo ];
    buildInputs = old.buildInputs ++ [
      zstd
      zlib
    ];
    env = (old.env or { }) // {
      NIX_CFLAGS_COMPILE = "${(old.env or { }).NIX_CFLAGS_COMPILE or ""} ${llvmExtraCflags}";
    };
    postPatch = ''
      ${old.postPatch or ""}
      patchShebangs lib/OffloadArch/make_generated_offload_arch_h.sh
    '';
    cmakeFlags = (builtins.filter tablegenUsage old.cmakeFlags) ++ commonCmakeFlags;
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
    }).overrideAttrs
      (old: {
        patches = builtins.filter (
          x: !(lib.strings.hasSuffix "more-openbsd-program-headers.patch" (builtins.baseNameOf x))
        ) old.patches;
        dontStrip = profilableStdenv;
        nativeBuildInputs = old.nativeBuildInputs ++ [
          removeReferencesTo
        ];
        buildInputs = old.buildInputs ++ [
          zstd
          zlib
        ];
        env = (old.env or { }) // {
          NIX_CFLAGS_COMPILE = "${(old.env or { }).NIX_CFLAGS_COMPILE or ""} ${llvmExtraCflags}";
        };
        cmakeFlags = (builtins.filter tablegenUsage old.cmakeFlags) ++ commonCmakeFlags;
        # Ensure we don't leak refs to compiler that was used to bootstrap this LLVM
        disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
        postFixup = ''
          ${old.postFixup or ""}
          find $lib -type f -exec remove-references-to -t ${stdenv.cc.cc} {} +
          find $lib -type f -exec remove-references-to -t ${stdenv.cc.bintools} {} +
        '';
      });
  clang-unwrapped =
    (
      (llvmPackagesRocm.clang-unwrapped.override {
        libllvm = llvm;
      }).overrideAttrs
      (
        old:
        let
          filteredPatches = builtins.filter (x: !(removeInapplicablePatches x)) old.patches;
        in
        {
          passthru = old.passthru // {
            inherit gcc-prefix;
          };
          meta.platforms = [
            "x86_64-linux"
          ];
          pname = "${old.pname}-rocm";
          patches = [
            (fetchpatch {
              # [PATCH] [clang] Install scan-build-py into plain "lib" directory
              # Backported so 19/clang/gnu-install-dirs patch applies to AMD's LLVM fork
              hash = "sha256-bOqAjBwRKcERpQkiBpuojGs6ddd5Ht3zL5l3TuJK2w8=";
              url = "https://github.com/llvm/llvm-project/commit/816fde1cbb700ebcc8b3df81fb93d675c04c12cd.patch";
              relative = "clang";
            })
          ]
          ++ filteredPatches
          ++ [
            # Never add FHS include paths
            ./clang-bodge-ignore-systemwide-incls.diff
            # Prevents builds timing out if a single compiler invocation is very slow but
            # per-arch jobs are completing by ensuring there's terminal output
            ./clang-log-jobs.diff
            ./opt-offload-compress-on-by-default.patch
            ./perf-shorten-gcclib-include-paths.patch
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
            removeReferencesTo
          ];
          buildInputs = old.buildInputs ++ [
            zstd
            zlib
          ];
          env = (old.env or { }) // {
            NIX_CFLAGS_COMPILE = "${(old.env or { }).NIX_CFLAGS_COMPILE or ""} ${llvmExtraCflags}";
          };
          dontStrip = profilableStdenv;
          # Ensure we don't leak refs to compiler that was used to bootstrap this LLVM
          disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
          # Enable structured attrs for separateDebugInfo, because it is required with disallowedReferences set
          __structuredAttrs = true;
          requiredSystemFeatures = (old.requiredSystemFeatures or [ ]) ++ [ "big-parallel" ];
          # https://github.com/llvm/llvm-project/blob/6976deebafa8e7de993ce159aa6b82c0e7089313/clang/cmake/caches/DistributionExample-stage2.cmake#L9-L11
          cmakeFlags =
            (builtins.filter tablegenUsage old.cmakeFlags)
            ++ commonCmakeFlags
            ++ lib.optionals (!withLibcxx) [
              # FIXME: Config file in rocmcxx instead of GCC_INSTALL_PREFIX?
              # Expected to be fully removed eventually
              "-DUSE_DEPRECATED_GCC_INSTALL_PREFIX=ON"
              "-DGCC_INSTALL_PREFIX=${gcc-prefix}"
            ];
          postFixup = (old.postFixup or "") + ''
            find $lib -type f -exec remove-references-to -t ${stdenvToBuildRocmLlvm} {} +
            find $lib -type f -exec remove-references-to -t ${stdenvToBuildRocmLlvm.cc} {} +
            find $lib -type f -exec remove-references-to -t ${stdenvToBuildRocmLlvm.cc.cc} {} +
            find $lib -type f -exec remove-references-to -t ${stdenv.cc} {} +
            find $lib -type f -exec remove-references-to -t ${stdenv.cc.cc} {} +
            find $lib -type f -exec remove-references-to -t ${stdenv.cc.bintools} {} +
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
          openmp
        ]
        ++ (lib.optionals withLibcxx [
          libcxx
        ])
        ++ (lib.optionals (!withLibcxx) [
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
      (fetchpatch {
        # Fixes fortify hardening compile error related to openat usage
        hash = "sha256-pgpN1q1vIQrPXHPxNSZ6zfgV2EflHO5Amzl+2BDjXbs=";
        url = "https://github.com/llvm/llvm-project/commit/155b7a12820ec45095988b6aa6e057afaf2bc892.patch";
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
    ++ lib.optionals withLibcxx [
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
    if withLibcxx then llvmPackagesRocm.libcxxStdenv else llvmPackagesRocm.stdenv
  ) clang;

  # Projects
  openmp =
    (llvmPackagesRocm.openmp.override {
      llvm = llvm;
      targetLlvm = llvm;
      clang-unwrapped = clang-unwrapped;
    }).overrideAttrs
      (old: {
        disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          removeReferencesTo
        ];
        cmakeFlags =
          old.cmakeFlags
          ++ commonCmakeFlags
          ++ [
            "-DDEVICELIBS_ROOT=${rocm-device-libs.src}"
            # OMPD support is broken in ROCm 6.3+ Haven't investigated why.
            "-DLIBOMP_OMPD_SUPPORT:BOOL=FALSE"
            "-DLIBOMP_OMPD_GDB_SUPPORT:BOOL=FALSE"
          ];
        buildInputs = old.buildInputs ++ [
          clang-unwrapped
          zlib
          zstd
          libxml2
          libffi
        ];
      });
}
