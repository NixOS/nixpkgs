{
  lib,
  stdenv,
  # LLVM version closest to ROCm fork to override
  llvmPackages_19,
  overrideCC,
  lndir,
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
  # leaving compressed line tables (-g1 -gz) unstripped
  # TODO: Should also apply to downstream packages which use rocmClangStdenv?
  profilableStdenv ? false,
  # Whether to use LTO when building the ROCm toolchain
  # Slows down this toolchain's build, for typical ROCm usecase
  # time saved building composable_kernel and other heavy packages
  # will outweight that. ~3-4% speedup multiplied by thousands
  # of corehours.
  withLto ? true,
  # whether rocm stdenv uses libcxx (clang c++ stdlib) instead of gcc stdlibc++
  withLibcxx ? false,
}@args:

let
  version = "6.4.3";
  # major version of this should be the clang version ROCm forked from
  rocmLlvmVersion = "19.0.0-rocm";
  # llvmPackages_base version should match rocmLlvmVersion
  # so libllvm's bitcode is compatible with the built toolchain
  llvmPackages_base = llvmPackages_19;
  llvmPackagesNoBintools = llvmPackages_base.override {
    bootBintools = null;
    bootBintoolsNoLibc = null;
  };

  stdenvToBuildRocmLlvm =
    if withLibcxx then
      overrideCC llvmPackagesNoBintools.libcxxStdenv llvmPackagesNoBintools.clangUseLLVM
    else
      # oddly fuse-ld=lld fails without this override
      overrideCC llvmPackagesNoBintools.stdenv (
        llvmPackagesNoBintools.libstdcxxClang.override {
          inherit (llvmPackages_base) bintools;
        }
      );

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
  # A prefix for use as the GCC prefix when building rocm-toolchain
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
  llvmSrc = fetchFromGitHub {
    owner = "ROCm";
    repo = "llvm-project";
    rev = "rocm-${version}";
    hash = "sha256-12ftH5fMPAsbcEBmhADwW1YY/Yxo/MAK1FafKczITMg=";
  };
  llvmMajorVersion = lib.versions.major rocmLlvmVersion;
  # An llvmPackages (pkgs/development/compilers/llvm/) built from ROCm LLVM's source tree
  llvmPackagesRocm = llvmPackages_base.override (_old: {
    stdenv = stdenvToBuildRocmLlvm;

    # not setting gitRelease = because that causes patch selection logic to use git patches
    # ROCm LLVM is closer to 20 official
    # gitRelease = {}; officialRelease = null;
    officialRelease = { }; # Set but empty because we're overriding everything from it.
    # this version determines which patches are applied
    version = rocmLlvmVersion;
    src = llvmSrc;
    monorepoSrc = llvmSrc;
    doCheck = false;
  });
  refsToRemove = builtins.concatStringsSep " -t " [
    stdenvToBuildRocmLlvm
    stdenvToBuildRocmLlvm.cc
    stdenvToBuildRocmLlvm.cc.cc
    stdenv.cc
    stdenv.cc.cc
    stdenv.cc.bintools
  ];
  sysrootCompiler =
    {
      cc,
      name,
      paths,
      linkPaths,
    }:
    let
      linked = symlinkJoin { inherit name paths; };
    in
    runCommand name
      {
        # If this is erroring, try why-depends --precise on the symlinkJoin of inputs to look for the problem
        # nix why-depends --precise .#rocmPackages.llvm.rocm-toolchain.linked /store/path/its/not/allowed
        disallowedRequisites = disallowedRefsForToolchain;
        passthru.linked = linked;
        linkPaths = linkPaths;
        passAsFile = [ "linkPaths" ];
        # TODO(@LunNova): Try to use --sysroot with clang in its original location instead of
        # relying on copying the binary?
        # $clang/bin/clang++ --sysroot=$rocm-toolchain is not equivalent
        # to a clang copied to $rocm-toolchain/bin here, have not yet figured out why
      }
      ''
        mkdir -p $out/
        cp --reflink=auto -rL ${linked}/* $out/
        chmod -R +rw $out
        mkdir -p $out/usr
        ln -s $out/ $out/usr/local
        # we don't need mixed 32 bit, the presence of lib64 is used by LLVM to decide it's a multilib sysroot
        rm -rf $out/lib64
        rm -rf $out/lib/cmake $out/lib/lib*.a
        mkdir -p $out/lib/clang/${llvmMajorVersion}/lib/linux/
        ln -s $out/lib/linux/libclang_rt.* $out/lib/clang/${llvmMajorVersion}/lib/linux/

        find $out -type f -exec sed -i "s|${cc.out}|$out|g" {} +
        find $out -type f -exec sed -i "s|${cc.dev}|$out|g" {} +

        ${lib.getExe rdfind} -makesymlinks true ${
          builtins.concatStringsSep " " (map (x: "${x}/lib") paths)
        } $out/ # create links *within* the sysroot to save space

        for i in $(cat $linkPathsPath); do
          ${lib.getExe lndir} -silent $i $out
        done

        echo 'export CC=clang' >> $out/nix-support/setup-hook
        echo 'export CXX=clang++' >> $out/nix-support/setup-hook
      '';
  # Removes patches which either aren't desired, or don't apply against ROCm LLVM
  removeInapplicablePatches =
    x:
    (
      (lib.strings.hasSuffix "add-nostdlibinc-flag.patch" (baseNameOf x))
      || (lib.strings.hasSuffix "clang-at-least-16-LLVMgold-path.patch" (baseNameOf x))
    );
  tablegenUsage = x: !(lib.strings.hasInfix "llvm-tblgen" x);
  llvmTargetsFlag = "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${
    {
      "x86_64" = "X86";
      "aarch64" = "AArch64";
    }
    .${stdenv.targetPlatform.parsed.cpu.name}
      or (throw "Unsupported CPU architecture: ${stdenv.targetPlatform.parsed.cpu.name}")
  }";
  llvmMeta = {
    # TODO(@LunNova): it would be nice to support aarch64 for rocmPackages
    platforms = [ "x86_64-linux" ];
  };
  # TODO(@LunNova): Some of this might be worth supporting in llvmPackages, dropping from here
  commonCmakeFlags = [
    llvmTargetsFlag
    # Compression support is required for compressed offload kernels
    # Set FORCE_ON so that failure to find the compression libs will be a build error
    (lib.cmakeFeature "LLVM_ENABLE_ZSTD" "FORCE_ON")
    (lib.cmakeFeature "LLVM_ENABLE_ZLIB" "FORCE_ON")
    # required for threaded ThinLTO to work
    (lib.cmakeBool "LLVM_ENABLE_THREADS" true)
    # LLVM tries to call git to embed VCS info if FORCE_VC_ aren't set
    (lib.cmakeFeature "LLVM_FORCE_VC_REVISION" "rocm-${version}")
    (lib.cmakeFeature "LLVM_FORCE_VC_REPOSITORY" "https://github.com/ROCm/llvm-project")
    (lib.cmakeFeature "LLVM_VERSION_SUFFIX" "")
    (lib.cmakeBool "LLVM_ENABLE_LIBCXX" withLibcxx)
    (lib.cmakeFeature "CLANG_DEFAULT_CXX_STDLIB" (if withLibcxx then "libc++" else "libstdc++"))
    (lib.cmakeFeature "CLANG_VENDOR" "nixpkgs-AMD")
    (lib.cmakeFeature "CLANG_REPOSITORY_STRING" "https://github.com/ROCm/llvm-project/tree/rocm-${version}")
  ]
  ++ lib.optionals withLibcxx [
    (lib.cmakeFeature "CLANG_DEFAULT_RTLIB" "compiler-rt")
  ]
  ++ lib.optionals withLto [
    (lib.cmakeBool "CMAKE_INTERPROCEDURAL_OPTIMIZATION" true)
    (lib.cmakeBool "LLVM_ENABLE_FATLTO" false)
  ]
  ++ lib.optionals (withLto && stdenvToBuildRocmLlvm.cc.isClang) [
    (lib.cmakeFeature "LLVM_ENABLE_LTO" "FULL")
    (lib.cmakeFeature "LLVM_USE_LINKER" "lld")
  ];

  llvmExtraCflags = lib.concatStringsSep " " (
    lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
      # Unprincipled decision to build x86_64 ROCm clang for at least skylake and tune for zen3+
      # In practice building the ROCm package set with anything earlier than zen3 is annoying
      # and earlier than skylake is implausible due to too few cores and too little RAM
      # Speeds up composable_kernel builds by ~4%
      # If this causes trouble in practice we can drop this. Set since 2025-03-24.
      "-march=skylake"
      "-mtune=znver3"
    ]
    ++ lib.optionals profilableStdenv [
      # compressed line only debug info for profiling
      "-gz"
      "-g1"
    ]
  );
in
rec {
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
    hardeningDisable = [ "all" ];
    nativeBuildInputs = old.nativeBuildInputs ++ [ removeReferencesTo ];
    buildInputs = old.buildInputs ++ [
      zstd
      zlib
    ];
    preFixup = ''
      moveToOutput "lib/lib*.a" "$dev"
      moveToOutput "lib/cmake" "$dev"
      sed -Ei "s|$lib/lib/(lib[^/]*)\.a|$dev/lib/\1.a|g" $dev/lib/cmake/llvm/*.cmake
    '';
    env = (old.env or { }) // {
      NIX_CFLAGS_COMPILE = "${(old.env or { }).NIX_CFLAGS_COMPILE or ""} ${llvmExtraCflags}";
    };
    cmakeFlags = (builtins.filter tablegenUsage old.cmakeFlags) ++ commonCmakeFlags;
    # Ensure we don't leak refs to compiler that was used to bootstrap this LLVM
    disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowedRefsForToolchain;
    postFixup = ''
      ${old.postFixup or ""}
      find $lib -type f -exec remove-references-to -t ${refsToRemove} {} +
    '';
    meta = old.meta // llvmMeta;
  });
  lld =
    (llvmPackagesRocm.lld.override {
      libllvm = llvm;
    }).overrideAttrs
      (old: {
        dontStrip = profilableStdenv;
        hardeningDisable = [ "all" ];
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
          find $lib -type f -exec remove-references-to -t ${refsToRemove} {} +
        '';
        meta = old.meta // llvmMeta;
      });
  clang-unwrapped = (
    (llvmPackagesRocm.clang-unwrapped.override {
      libllvm = llvm;
      enableClangToolsExtra = false;
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
          hardeningDisable = [ "all" ];
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
          # https://github.com/llvm/llvm-project/blob/6976deebafa8e7de993ce159aa6b82c0e7089313/clang/cmake/caches/DistributionExample-stage2.cmake#L9-L11
          cmakeFlags =
            (builtins.filter tablegenUsage old.cmakeFlags)
            ++ commonCmakeFlags
            ++ lib.optionals (!withLibcxx) [
              # FIXME: Config file in rocm-toolchain instead of GCC_INSTALL_PREFIX?
              # Expected to be fully removed eventually
              "-DUSE_DEPRECATED_GCC_INSTALL_PREFIX=ON"
              "-DGCC_INSTALL_PREFIX=${gcc-prefix}"
            ];
          preFixup = ''
            ${toString old.preFixup or ""}
            moveToOutput "lib/lib*.a" "$dev"
            moveToOutput "lib/cmake" "$dev"
            mkdir -p $dev/lib/clang/
            ln -s $lib/lib/clang/${llvmMajorVersion} $dev/lib/clang/
            sed -Ei "s|$lib/lib/(lib[^/]*)\.a|$dev/lib/\1.a|g" $dev/lib/cmake/clang/*.cmake
          '';
          postFixup = ''
            ${toString old.postFixup or ""}
            find $lib -type f -exec remove-references-to -t ${refsToRemove} {} +
            find $dev -type f -exec remove-references-to -t ${refsToRemove} {} +
          '';
          meta = old.meta // llvmMeta;
        }
      )
  );
  # A clang that understands standard include searching in a GNU sysroot and will put GPU libs in include path
  # in the right order
  # and expects its libc to be in the sysroot
  rocm-toolchain =
    (sysrootCompiler {
      cc = clang-unwrapped;
      name = "rocm-toolchain";
      paths = [
        clang-unwrapped.out
        clang-unwrapped.lib
        bintools.out
        compiler-rt.out
        openmp.out
        openmp.dev
      ]
      ++ lib.optionals withLibcxx [
        libcxx
      ]
      ++ lib.optionals (!withLibcxx) [
        glibc
        glibc.dev
      ];
      linkPaths = [
        bintools.bintools.out
      ]
      ++ lib.optionals (!withLibcxx) [
        gcc-include.out
      ];
    })
    // {
      version = llvmMajorVersion;
      cc = rocm-toolchain;
      libllvm = llvm;
      isClang = true;
      isGNU = false;
    };
  compiler-rt-libc =
    (llvmPackagesRocm.compiler-rt-libc.override {
      libllvm = llvm;
    }).overrideAttrs
      (old: {
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
        meta = old.meta // llvmMeta;
      });
  compiler-rt = compiler-rt-libc;
  bintools = wrapBintoolsWith {
    bintools = llvmPackagesRocm.bintools-unwrapped.override {
      inherit lld llvm;
    };
  };

  clang = rocm-toolchain;

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
