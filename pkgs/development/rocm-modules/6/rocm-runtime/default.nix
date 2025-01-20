{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  pkg-config,
  cmake,
  ninja,
  xxd,
  rocm-device-libs,
  elfutils,
  libdrm,
  numactl,
  valgrind,
  libxml2,
  rocm-merged-llvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-runtime";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCR-Runtime";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-btpiIPV9REMvrmRSUzBIpBO6ehVIMmEmG+H8hqHDxdE=";
  };

  env.CFLAGS = "-I${numactl.dev}/include -I${elfutils.dev}/include -w";
  env.CXXFLAGS = "-I${numactl.dev}/include -I${elfutils.dev}/include -w";

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    xxd
    rocm-merged-llvm
  ];

  buildInputs = [
    elfutils
    libdrm
    numactl
    valgrind
    libxml2
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  patches = [
    # (fetchpatch {
    #   name = "extend-isa-compatibility-check.patch";
    #   url = "https://salsa.debian.org/rocm-team/rocr-runtime/-/raw/076026d43bbee7f816b81fea72f984213a9ff961/debian/patches/0004-extend-isa-compatibility-check.patch";
    #   hash = "sha256-cC030zVGS4kNXwaztv5cwfXfVwOldpLGV9iYgEfPEnY=";
    #   stripLen = 1;
    # })
    ./remove-hsa-aqlprofile-dep.patch
    ./ub.patch
  ];

  postPatch = ''
    patchShebangs --host image
    patchShebangs --host core
    patchShebangs --host runtime

    substituteInPlace CMakeLists.txt \
      --replace 'hsa/include/hsa' 'include/hsa'

    # We compile clang before rocm-device-libs, so patch it in afterwards
    # Replace object version: https://github.com/ROCm/ROCR-Runtime/issues/166 (TODO: Remove on LLVM update?)
    # substituteInPlace image/blit_src/CMakeLists.txt \
    #   --replace '-cl-denorms-are-zero' '-cl-denorms-are-zero --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode' \
    #   --replace '-mcode-object-version=4' '-mcode-object-version=5'

    export HIP_DEVICE_LIB_PATH="${rocm-device-libs}/amdgcn/bitcode"
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/ROCm/ROCR-Runtime";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
