{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-device-libs
, libxml2
}:

let
  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-comgr";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "llvm-project";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-+pe3e65Ri5zOOYvoSUiN0Rto/Ss8OyRfqxRifToAO7g=";
  };

  sourceRoot = "${finalAttrs.src.name}/amd/comgr";

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocm-device-libs
    libxml2
  ];

  patches = [
    (fetchpatch {
      name = "extend-comgr-isa-compatibility.patch";
      url = "https://github.com/GZGavinZhao/ROCm-CompilerSupport/commit/ae653fb884fb1e3b4d9fd79fb727b3b027ca69ac.patch";
      stripLen = 3;
      extraPrefix = "";
      hash = "sha256-cEzIKEDHaJXrQnnnt2rohPqlfoBM8czr7qz+HIQdkro=";
    })
    (fetchpatch {
      name = "add-offload-bundler-apis.patch";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/f589e773857bc7115ac20a6cc606e94dd1123357.patch";
      stripLen = 3;
      extraPrefix = "";
      hash = "sha256-DcbpCIKqfZJ//BbZ2Lx2ZXYAEkCvTIlFna8ceSWF1IA=";
    })
    (fetchpatch {
      name = "split-get_bundle_entry_ids.patch";
      url = "https://github.com/GZGavinZhao/rocm-llvm-project/commit/e773c2c90cfaa2ead378127538a58129ba0708b0.patch";
      stripLen = 3;
      extraPrefix = "";
      hash = "sha256-a7hFT+IsNhpzuYoIPuXc2qmh3sgvafXz4Rvn9dA0Xoc=";
    })
  ];

  cmakeFlags = [ "-DLLVM_TARGETS_TO_BUILD=AMDGPU;X86" ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/ROCm/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "7.0.0";
  };
})
