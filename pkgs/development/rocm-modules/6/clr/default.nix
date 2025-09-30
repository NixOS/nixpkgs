{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
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
  inherit (rocm-core) ROCM_LIBPATCH_VERSION;
  hipClang = rocm-merged-llvm;
  hipClangPath = "${hipClang}/bin";
  wrapperArgs = [
    "--prefix PATH : $out/bin"
    "--prefix LD_LIBRARY_PATH : ${rocm-runtime}"
    "--set HIP_PLATFORM amd"
    "--set HIP_PATH $out"
    "--set HIP_CLANG_PATH ${hipClangPath}"
    "--set DEVICE_LIB_PATH ${rocm-device-libs}/amdgcn/bitcode"
    "--set HSA_PATH ${rocm-runtime}"
    "--set ROCM_PATH $out"
  ];
  amdclang = writeShellScriptBin "amdclang" ''
    exec clang "$@"
  '';
  amdclangxx = writeShellScriptBin "amdclang++" ''
    exec clang++ "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clr";
  version = "6.3.3";

  outputs = [
    "out"
    "icd"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "clr";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-4qjfnn0kto2sNaSumXxHRHFrf3a3RZILOdhVSxkEs1I=";
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
    hipClang
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

  patches = [
    ./cmake-find-x11-libgl.patch

    (fetchpatch {
      # Fix handling of old fatbin version https://github.com/ROCm/clr/issues/99
      sha256 = "sha256-CK/QwgWJQEruiG4DqetF9YM0VEWpSiUMxAf1gGdJkuA=";
      url = "https://src.fedoraproject.org/rpms/rocclr/raw/rawhide/f/0001-handle-v1-of-compressed-fatbins.patch";
    })
    (fetchpatch {
      # improve rocclr isa compatibility check
      sha256 = "sha256-wUrhpYN68AbEXeFU5f366C6peqHyq25kujJXY/bBJMs=";
      url = "https://github.com/GZGavinZhao/clr/commit/22c17a0ac09c6b77866febf366591f669a1ed133.patch";
    })
    (fetchpatch {
      # [PATCH] Improve hipamd compat check
      sha256 = "sha256-uZQ8rMrWH61CCbxwLqQGggDmXFmYTi6x8OcgYPrZRC8=";
      url = "https://github.com/GZGavinZhao/clr/commit/63c6ee630966744d4199fdfb854e98d2da9e1122.patch";
    })
    (fetchpatch {
      # [PATCH] SWDEV-504340 - Move cast of cl_mem inside the condition
      # Fixes crash due to UB in KernelBlitManager::setArgument
      sha256 = "sha256-nL4CZ7EOXqsTVUtYhuu9DLOMpnMeMRUhkhylEQLTg9I=";
      url = "https://github.com/ROCm/clr/commit/fa63919a6339ea2a61111981ba2362c97fbdf743.patch";
    })
    (fetchpatch {
      # [PATCH] SWDEV-507104 - Removes alignment requirement for Semaphore class to resolve runtime misaligned memory issues
      sha256 = "sha256-nStJ22B/CM0fzQTvYjbHDbQt0GlE8DXxVK+UDU9BAx4=";
      url = "https://github.com/ROCm/clr/commit/21d764518363d74187deaef2e66c1a127bc5aa64.patch";
    })
  ];

  postPatch = ''
    patchShebangs hipamd/*.sh
    patchShebangs hipamd/src

    # We're not on Windows so these are never installed to hipcc...
    substituteInPlace hipamd/CMakeLists.txt \
      --replace-fail "install(PROGRAMS \''${HIPCC_BIN_DIR}/hipcc.bat DESTINATION bin)" "" \
      --replace-fail "install(PROGRAMS \''${HIPCC_BIN_DIR}/hipconfig.bat DESTINATION bin)" ""

    substituteInPlace hipamd/src/hip_embed_pch.sh \
      --replace-fail "\''$LLVM_DIR/bin/clang" "${hipClangPath}/clang"

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

    for prog in hip{cc,config}{,.pl}; do
      wrapProgram $out/bin/$prog ${lib.concatStringsSep " " wrapperArgs}
    done

    mkdir -p $out/nix-support/
    echo '
    export HIP_PATH="${placeholder "out"}"
    export HIP_PLATFORM=amd
    export HIP_DEVICE_LIB_PATH="${rocm-device-libs}/amdgcn/bitcode"
    export NIX_CC_USE_RESPONSE_FILE=0
    export HIP_CLANG_PATH="${hipClangPath}"
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

    ln -s ${hipClang} $out/llvm
  '';

  disallowedRequisites = [
    gcc-unwrapped
  ];

  passthru = {
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
      "1151" # Strix Halo
      "1200" # RX 9070
      "1201" # RX 9070 XT
    ] (target: "gfx${target}");

    inherit hipClangPath;

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
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
