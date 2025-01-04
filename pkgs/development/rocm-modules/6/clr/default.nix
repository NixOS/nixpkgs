{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rocmUpdateScript,
  makeWrapper,
  cmake,
  perl,
  hip-common,
  hipcc,
  rocm-device-libs,
  rocm-comgr,
  rocm-runtime,
  rocm-core,
  roctracer,
  rocminfo,
  rocm-smi,
  numactl,
  libffi,
  zstd,
  zlib,
  libGL,
  libxml2,
  libX11,
  python3Packages,
  rocm-merged-llvm,
  khronos-ocl-icd-loader,
  gcc-unwrapped,
  writeShellScriptBin,
  localGpuTargets ? null,
}:

let
  hipClangPath = rocm-merged-llvm;
  wrapperArgs = [
    "--prefix PATH : $out/bin"
    "--prefix LD_LIBRARY_PATH : ${rocm-runtime}"
    "--set HIP_PLATFORM amd"
    "--set HIP_PATH $out"
    "--set HIP_CLANG_PATH ${hipClangPath}/bin"
    "--set DEVICE_LIB_PATH ${rocm-device-libs}/amdgcn/bitcode"
    "--set HSA_PATH ${rocm-runtime}"
    "--set ROCM_PATH $out"
  ];
  ROCM_LIBPATCH_VERSION = rocm-core.ROCM_LIBPATCH_VERSION;
  amdclang = writeShellScriptBin "amdclang" ''
    exec clang "$@"
  '';
  amdclangxx = writeShellScriptBin "amdclang++" ''
    exec clang++ "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clr";
  version = "6.3.1";

  outputs = [
    "out"
    "icd"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "clr";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-wo3kwk6HQJsP+ycaVh2mmMjEgGlj/Z6KXNXOXbJ1KLs=";
  };

  nativeBuildInputs = [
    makeWrapper
    cmake
    perl
    python3Packages.python
    python3Packages.cppheaderparser
    amdclang
    amdclangxx
  ];

  buildInputs = [
    numactl
    libGL
    libxml2
    libX11
    khronos-ocl-icd-loader
    hipClangPath
    libffi
    zstd
    zlib
  ];

  propagatedBuildInputs = [
    rocm-core
    rocm-device-libs
    rocm-comgr
    rocm-runtime
    rocminfo
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POLICY_DEFAULT_CMP0072=NEW" # Prefer newer OpenGL libraries
    "-DCLR_BUILD_HIP=ON"
    "-DCLR_BUILD_OCL=ON"
    "-DHIP_COMMON_DIR=${hip-common}"
    "-DHIPCC_BIN_DIR=${hipcc}/bin"
    "-DHIP_PLATFORM=amd"
    "-DPROF_API_HEADER_PATH=${roctracer.src}/inc/ext"
    "-DROCM_PATH=${rocminfo}"
    "-DBUILD_ICD=ON"
    "-DHIP_ENABLE_ROCPROFILER_REGISTER=OFF" # circular dep - may need -minimal and -full builds?
    "-DAMD_ICD_LIBRARY_DIR=${khronos-ocl-icd-loader}"

    # Temporarily set variables to work around upstream CMakeLists issue
    # Can be removed once https://github.com/ROCm/rocm-cmake/issues/121 is fixed
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  env.LLVM_DIR = "";

  # TODO: rebase patches
  patches = [
    ./cmake-find-x11-libgl.patch
    ./0001-handle-v1-of-compressed-fatbins.patch # https://github.com/ROCm/clr/issues/99
    # ./fix-null-stream-sync-perf.patch # https://github.com/ROCm/clr/issues/78
    # (fetchpatch {
    #   name = "add-missing-operators.patch";
    #   url = "https://github.com/ROCm/clr/commit/86bd518981b364c138f9901b28a529899d8654f3.patch";
    #   hash = "sha256-lbswri+zKLxif0hPp4aeJDeVfadhWZz4z+m+G2XcCPI=";
    # })
    # (fetchpatch {
    #   name = "static-functions.patch";
    #   url = "https://github.com/ROCm/clr/commit/77c581a3ebd47b5e2908973b70adea66891159ee.patch";
    #   hash = "sha256-auBedbd7rghlKav7A9V6l64J7VmtE9GizIdi5gWj+fs=";
    # })

    # (fetchpatch {
    #   name = "extend-hip-isa-compatibility-check.patch";
    #   url = "https://salsa.debian.org/rocm-team/rocm-hipamd/-/raw/d6d20142c37e1dff820950b16ff8f0523241d935/debian/patches/0026-extend-hip-isa-compatibility-check.patch";
    #   hash = "sha256-eG0ALZZQLRzD7zJueJFhi2emontmYy6xx8Rsm346nQI=";
    # })
    # (fetchpatch {
    #   name = "improve-rocclr-isa-compatibility-check.patch";
    #   url = "https://salsa.debian.org/rocm-team/rocm-hipamd/-/raw/d6d20142c37e1dff820950b16ff8f0523241d935/debian/patches/0025-improve-rocclr-isa-compatibility-check.patch";
    #   hash = "sha256-8eowuRiOAdd9ucKv4Eg9FPU7c6367H3eP3fRAGfXc6Y=";
    # })
  ];

  postPatch = ''
    patchShebangs hipamd/*.sh
    patchShebangs hipamd/src

    # We're not on Windows so these are never installed to hipcc...
    substituteInPlace hipamd/CMakeLists.txt \
      --replace "install(PROGRAMS \''${HIPCC_BIN_DIR}/hipcc.bat DESTINATION bin)" "" \
      --replace "install(PROGRAMS \''${HIPCC_BIN_DIR}/hipconfig.bat DESTINATION bin)" ""

    substituteInPlace hipamd/src/hip_embed_pch.sh \
      --replace "\''$LLVM_DIR/bin/clang" "${hipClangPath}/bin/clang"

    substituteInPlace opencl/khronos/icd/loader/icd_platform.h \
      --replace-fail '#define ICD_VENDOR_PATH "/etc/OpenCL/vendors/";' \
                     '#define ICD_VENDOR_PATH "/run/opengl-driver/etc/OpenCL/vendors/";'

    # new unbundler has better error messages, defaulting it on
    substituteInPlace rocclr/utils/flags.hpp \
      --replace-fail "HIP_ALWAYS_USE_NEW_COMGR_UNBUNDLING_ACTION, false" "HIP_ALWAYS_USE_NEW_COMGR_UNBUNDLING_ACTION, true"
  '';

  postInstall = ''
    chmod +x $out/bin/*
    patchShebangs $out/bin

    cp ${amdclang}/bin/* $out/bin/
    cp ${amdclangxx}/bin/* $out/bin/

    wrapProgram $out/bin/hipcc ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipconfig ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipcc.pl ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipconfig.pl ${lib.concatStringsSep " " wrapperArgs}

    mkdir -p $out/nix-support/
    echo '
    CORE_LIM="''${NIX_BUILD_CORES:-1}"
    if ((CORE_LIM <= 0)); then
        guess=$(nproc 2>/dev/null || true)
        ((CORE_LIM = guess <= 1 ? 1 : guess))
        ((CORE_LIM = CORE_LIM >= 3 ? 3 : CORE_LIM))
    fi
    CORE_LIM=$(( ''${NIX_LOAD_LIMIT:-''${CORE_LIM:-$(nproc)}} / 2 ))
    # Set HIPCC_JOBS with min and max constraints
    export HIPCC_JOBS=$CORE_LIM
    export HIPCC_JOBS_LINK=$CORE_LIM
    export CFLAGS="''${CFLAGS:-} -parallel-jobs=$CORE_LIM"
    export CXXFLAGS="''${CXXFLAGS:-} -parallel-jobs=$CORE_LIM"
    #export HIPCC_COMPILE_FLAGS_APPEND="-O3 -Wno-format-nonliteral -parallel-jobs=$HIPCC_JOBS"
    export HIP_PATH="${placeholder "out"}"
    export HIP_PLATFORM=amd
    export HIP_DEVICE_LIB_PATH="${rocm-device-libs}/amdgcn/bitcode"
    export NIX_CC_USE_RESPONSE_FILE=0
    export HIP_CLANG_PATH="${hipClangPath}/bin"
    export ROCM_LIBPATCH_VERSION="${ROCM_LIBPATCH_VERSION}"
    export HSA_PATH="${rocm-runtime}"' > $out/nix-support/setup-hook

    # Just link rocminfo, it's easier
    ln -s ${rocminfo}/bin/* $out/bin
    ln -s ${rocm-core}/include/* $out/include/

    # Replace rocm-opencl-icd functionality
    mkdir -p $icd/etc/OpenCL/vendors
    echo "$out/lib/libamdocl64.so" > $icd/etc/OpenCL/vendors/amdocl64.icd

    # add version info to output (downstream rocmPackages look for this)
    ln -s ${rocm-core}/.info/ $out/.info

    ln -s ${hipClangPath} $out/llvm
  '';

  disallowedRequisites = [
    gcc-unwrapped
  ];
  # postFixup = ''
  #   objdump --syms $out/lib/libamdhip64.so.6
  #   readelf --debug-dump=line $out/lib/libamdhip64.so.6
  #   exit 1
  # '';

  passthru =
    {
      # All known and valid general GPU targets
      # We cannot use this for each ROCm library, as each defines their own supported targets
      # See: https://github.com/ROCm/ROCm/blob/77cbac4abab13046ee93d8b5bf410684caf91145/README.md#library-target-matrix
      # Generic targets are not yet available in rocm-6.3.1 llvm
      gpuTargets = lib.forEach [
        # "9-generic"
        "900" # MI25, Vega 56/64
        "906" # MI50/60, Radeon VII
        "908" # MI100
        "90a" # MI210 / MI250
        # "9-4-generic"
        # 940/1 - never released publicly, maybe HPE cray specific MI3xx?
        "942" # MI300
        # "10-1-generic"
        "1010"
        "1012"
        # "10-3-generic"
        "1030" # W6800, various Radeon cards
        # "11-generic"
        "1100"
        "1101"
        "1102"
      ] (target: "gfx${target}");

      updateScript = rocmUpdateScript {
        name = finalAttrs.pname;
        inherit (finalAttrs.src) owner;
        inherit (finalAttrs.src) repo;
        page = "tags?per_page=4";
      };

      impureTests = {
        rocm-smi = callPackage ./test-rocm-smi.nix {
          inherit rocm-smi;
          clr = finalAttrs.finalPackage;
        };
        opencl-example = callPackage ./test-opencl-example.nix {
          clr = finalAttrs.finalPackage;
        };
      };

      selectGpuTargets =
        {
          supported ? [ ],
        }:
        supported;
      gpuArchSuffix = "";
    }
    // lib.optionalAttrs (localGpuTargets != null) {
      inherit localGpuTargets;
      gpuArchSuffix = "-" + (builtins.concatStringsSep "-" localGpuTargets);
      selectGpuTargets =
        {
          supported ? [ ],
        }:
        if supported == [ ] then localGpuTargets else lib.lists.intersectLists localGpuTargets supported;
    };

  meta = with lib; {
    description = "AMD Common Language Runtime for hipamd, opencl, and rocclr";
    homepage = "https://github.com/ROCm/clr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
