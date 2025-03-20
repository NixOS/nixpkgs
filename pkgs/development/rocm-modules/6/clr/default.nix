{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  rocmUpdateScript,
  makeWrapper,
  cmake,
  perl,
  clang,
  hip-common,
  hipcc,
  rocm-device-libs,
  rocm-comgr,
  rocm-runtime,
  roctracer,
  rocminfo,
  rocm-smi,
  numactl,
  libGL,
  libxml2,
  libX11,
  python3Packages,
}:

let
  wrapperArgs = [
    "--prefix PATH : $out/bin"
    "--prefix LD_LIBRARY_PATH : ${rocm-runtime}"
    "--set HIP_PLATFORM amd"
    "--set HIP_PATH $out"
    "--set HIP_CLANG_PATH ${clang}/bin"
    "--set DEVICE_LIB_PATH ${rocm-device-libs}/amdgcn/bitcode"
    "--set HSA_PATH ${rocm-runtime}"
    "--set ROCM_PATH $out"
  ];

  # https://github.com/NixOS/nixpkgs/issues/305641
  # Not needed when 3.29.2 is in unstable
  cmake' = cmake.overrideAttrs (old: rec {
    version = "3.29.2";
    src = fetchurl {
      url = "https://cmake.org/files/v${lib.versions.majorMinor version}/cmake-${version}.tar.gz";
      hash = "sha256-NttLaSaqt0G6bksuotmckZMiITIwi03IJNQSPLcwNS4=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clr";
  version = "6.0.2";

  outputs = [
    "out"
    "icd"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "clr";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-ZMpA7vCW2CcpGdBLZfPimMHcgjhN1PHuewJiYwZMgGY=";
  };

  nativeBuildInputs = [
    makeWrapper
    cmake'
    perl
    python3Packages.python
    python3Packages.cppheaderparser
  ];

  buildInputs = [
    numactl
    libGL
    libxml2
    libX11
  ];

  propagatedBuildInputs = [
    rocm-device-libs
    rocm-comgr
    rocm-runtime
    rocminfo
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_DEFAULT_CMP0072=NEW" # Prefer newer OpenGL libraries
    "-DCLR_BUILD_HIP=ON"
    "-DCLR_BUILD_OCL=ON"
    "-DHIP_COMMON_DIR=${hip-common}"
    "-DHIPCC_BIN_DIR=${hipcc}/bin"
    "-DHIP_PLATFORM=amd"
    "-DPROF_API_HEADER_PATH=${roctracer.src}/inc/ext"
    "-DROCM_PATH=${rocminfo}"

    # Temporarily set variables to work around upstream CMakeLists issue
    # Can be removed once https://github.com/ROCm/rocm-cmake/issues/121 is fixed
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  patches = [
    (fetchpatch {
      name = "add-missing-operators.patch";
      url = "https://github.com/ROCm/clr/commit/86bd518981b364c138f9901b28a529899d8654f3.patch";
      hash = "sha256-lbswri+zKLxif0hPp4aeJDeVfadhWZz4z+m+G2XcCPI=";
    })
    (fetchpatch {
      name = "static-functions.patch";
      url = "https://github.com/ROCm/clr/commit/77c581a3ebd47b5e2908973b70adea66891159ee.patch";
      hash = "sha256-auBedbd7rghlKav7A9V6l64J7VmtE9GizIdi5gWj+fs=";
    })
    (fetchpatch {
      name = "extend-hip-isa-compatibility-check.patch";
      url = "https://salsa.debian.org/rocm-team/rocm-hipamd/-/raw/d6d20142c37e1dff820950b16ff8f0523241d935/debian/patches/0026-extend-hip-isa-compatibility-check.patch";
      hash = "sha256-eG0ALZZQLRzD7zJueJFhi2emontmYy6xx8Rsm346nQI=";
    })
    (fetchpatch {
      name = "improve-rocclr-isa-compatibility-check.patch";
      url = "https://salsa.debian.org/rocm-team/rocm-hipamd/-/raw/d6d20142c37e1dff820950b16ff8f0523241d935/debian/patches/0025-improve-rocclr-isa-compatibility-check.patch";
      hash = "sha256-8eowuRiOAdd9ucKv4Eg9FPU7c6367H3eP3fRAGfXc6Y=";
    })
  ];

  postPatch = ''
    patchShebangs hipamd/*.sh
    patchShebangs hipamd/src

    # We're not on Windows so these are never installed to hipcc...
    substituteInPlace hipamd/CMakeLists.txt \
      --replace "install(PROGRAMS \''${HIPCC_BIN_DIR}/hipcc.bat DESTINATION bin)" "" \
      --replace "install(PROGRAMS \''${HIPCC_BIN_DIR}/hipconfig.bat DESTINATION bin)" ""

    substituteInPlace hipamd/src/hip_embed_pch.sh \
      --replace "\''$LLVM_DIR/bin/clang" "${clang}/bin/clang"

    # https://lists.debian.org/debian-ai/2024/02/msg00178.html
    substituteInPlace rocclr/utils/flags.hpp \
      --replace-fail "HIP_USE_RUNTIME_UNBUNDLER, false" "HIP_USE_RUNTIME_UNBUNDLER, true"

    substituteInPlace opencl/khronos/icd/loader/icd_platform.h \
      --replace-fail '#define ICD_VENDOR_PATH "/etc/OpenCL/vendors/";' \
                     '#define ICD_VENDOR_PATH "/run/opengl-driver/etc/OpenCL/vendors/";'
  '';

  postInstall = ''
    patchShebangs $out/bin

    # hipcc.bin and hipconfig.bin is mysteriously never installed
    cp -a ${hipcc}/bin/{hipcc.bin,hipconfig.bin} $out/bin

    wrapProgram $out/bin/hipcc.bin ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipconfig.bin ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipcc.pl ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipconfig.pl ${lib.concatStringsSep " " wrapperArgs}

    # Just link rocminfo, it's easier
    ln -s ${rocminfo}/bin/* $out/bin

    # Replace rocm-opencl-icd functionality
    mkdir -p $icd/etc/OpenCL/vendors
    echo "$out/lib/libamdocl64.so" > $icd/etc/OpenCL/vendors/amdocl64.icd

    # add version info to output (downstream rocmPackages look for this)
    mkdir $out/.info
    echo "${finalAttrs.version}" > $out/.info/version
  '';

  passthru = {
    # All known and valid general GPU targets
    # We cannot use this for each ROCm library, as each defines their own supported targets
    # See: https://github.com/ROCm/ROCm/blob/77cbac4abab13046ee93d8b5bf410684caf91145/README.md#library-target-matrix
    gpuTargets = lib.forEach [
      "803"
      "900"
      "906"
      "908"
      "90a"
      "940"
      "941"
      "942"
      "1010"
      "1012"
      "1030"
      "1100"
      "1101"
      "1102"
    ] (target: "gfx${target}");

    updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      owner = finalAttrs.src.owner;
      repo = finalAttrs.src.repo;
      page = "tags?per_page=1";
      filter = ".[0].name | split(\"-\") | .[1]";
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
  };

  meta = with lib; {
    description = "AMD Common Language Runtime for hipamd, opencl, and rocclr";
    homepage = "https://github.com/ROCm/clr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
