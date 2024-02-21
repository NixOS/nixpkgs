{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, buildEnv
, linkFarm
, overrideCC
, makeWrapper
, stdenv

, cmake
, gcc12
, clblast
, libdrm
, rocmPackages
, cudaPackages
, linuxPackages
, darwin

, enableRocm ? false
, enableCuda ? false
}:

let
  pname = "ollama";
  version = "0.1.26";

  warnIfNotLinux = warning: (lib.warnIfNot stdenv.isLinux warning stdenv.isLinux);
  gpuWarning = api: "building ollama with ${api} is only supported on linux; falling back to cpu";
  rocmIsEnabled = enableRocm && (warnIfNotLinux (gpuWarning "rocm"));
  cudaIsEnabled = enableCuda && (warnIfNotLinux (gpuWarning "cuda"));
  enableLinuxGpu = rocmIsEnabled || cudaIsEnabled;

  appleFrameworks = darwin.apple_sdk_11_0.frameworks;
  metalFrameworks = [
    appleFrameworks.Accelerate
    appleFrameworks.Metal
    appleFrameworks.MetalKit
    appleFrameworks.MetalPerformanceShaders
  ];

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-Kw3tt9ayEMgI2V6OeaOkWfNwqfCL7MDD/nN5iXk5LnY=";
    fetchSubmodules = true;
  };
  preparePatch = patch: hash: fetchpatch {
    url = "file://${src}/llm/patches/${patch}";
    inherit hash;
    stripLen = 1;
    extraPrefix = "llm/llama.cpp/";
  };
  inherit (lib) licenses platforms maintainers;
  ollama = {
    inherit pname version src;
    vendorHash = "sha256-zTrBighPBqZ9hhkEV3UawJZUYyPRay7+P6wkhDtpY7M=";

    nativeBuildInputs = [
      cmake
    ] ++ lib.optionals enableLinuxGpu [
      makeWrapper
    ] ++ lib.optionals stdenv.isDarwin
      metalFrameworks;

    patches = [
      # remove uses of `git` in the `go generate` script
      # instead use `patch` where necessary
      ./remove-git.patch
      # replace a hardcoded use of `g++` with `$CXX`
      ./replace-gcc.patch

      # ollama's patches of llama.cpp's example server
      # `ollama/llm/generate/gen_common.sh` -> "apply temporary patches until fix is upstream"
      (preparePatch "01-cache.diff" "sha256-MTTln2G0G8dntihUzEjPM1ruTsApb4ZToBczJb8EG68=")
      (preparePatch "02-cudaleaks.diff" "sha256-Cu7E9iEcvddPL9mPPI5Z96qmwWigi3f0WgSpPRjGc88=")
    ];
    postPatch = ''
      # use a patch from the nix store in the `go generate` script
      substituteInPlace llm/generate/gen_common.sh \
        --subst-var-by cmakeIncludePatch '${./cmake-include.patch}'
      # `ollama/llm/generate/gen_common.sh` -> "avoid duplicate main symbols when we link into the cgo binary"
      substituteInPlace llm/llama.cpp/examples/server/server.cpp \
        --replace-fail 'int main(' 'int __main('
      # replace inaccurate version number with actual release version
      substituteInPlace version/version.go --replace-fail 0.0.0 '${version}'
    '';
    preBuild = ''
      export OLLAMA_SKIP_PATCHING=true
      # build llama.cpp libraries for ollama
      go generate ./...
    '';

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/jmorganca/ollama/version.Version=${version}"
      "-X=github.com/jmorganca/ollama/server.mode=release"
    ];

    meta = {
      description = "Get up and running with large language models locally";
      homepage = "https://github.com/jmorganca/ollama";
      license = licenses.mit;
      platforms = platforms.unix;
      mainProgram = "ollama";
      maintainers = with maintainers; [ abysssol dit7ya elohmeier ];
    };
  };


  rocmClang = linkFarm "rocm-clang" {
    llvm = rocmPackages.llvm.clang;
  };
  rocmPath = buildEnv {
    name = "rocm-path";
    paths = [
      rocmPackages.rocm-device-libs
      rocmClang
    ];
  };
  rocmVars = {
    ROCM_PATH = rocmPath;
    CLBlast_DIR = "${clblast}/lib/cmake/CLBlast";
  };

  cudaToolkit = buildEnv {
    name = "cuda-toolkit";
    ignoreCollisions = true; # FIXME: find a cleaner way to do this without ignoring collisions
    paths = [
      cudaPackages.cudatoolkit
      cudaPackages.cuda_cudart
    ];
  };
  cudaVars = {
    CUDA_LIB_DIR = "${cudaToolkit}/lib";
    CUDACXX = "${cudaToolkit}/bin/nvcc";
    CUDAToolkit_ROOT = cudaToolkit;
  };

  linuxGpuLibs = {
    buildInputs = lib.optionals rocmIsEnabled [
      rocmPackages.clr
      rocmPackages.hipblas
      rocmPackages.rocblas
      rocmPackages.rocsolver
      rocmPackages.rocsparse
      libdrm
    ] ++ lib.optionals cudaIsEnabled [
      cudaPackages.cuda_cudart
    ];
  };

  appleGpuLibs = { buildInputs = metalFrameworks; };

  runtimeLibs = lib.optionals rocmIsEnabled [
    rocmPackages.rocm-smi
  ] ++ lib.optionals cudaIsEnabled [
    linuxPackages.nvidia_x11
  ];
  runtimeLibWrapper = {
    postFixup = ''
      mv "$out/bin/${pname}" "$out/bin/.${pname}-unwrapped"
      makeWrapper "$out/bin/.${pname}-unwrapped" "$out/bin/${pname}" \
        --suffix LD_LIBRARY_PATH : '${lib.makeLibraryPath runtimeLibs}'
    '';
  };

  goBuild =
    if cudaIsEnabled then
      buildGoModule.override { stdenv = overrideCC stdenv gcc12; }
    else
      buildGoModule;
in
goBuild (ollama
  // (lib.optionalAttrs rocmIsEnabled rocmVars)
  // (lib.optionalAttrs cudaIsEnabled cudaVars)
  // (lib.optionalAttrs enableLinuxGpu linuxGpuLibs)
  // (lib.optionalAttrs enableLinuxGpu runtimeLibWrapper)

  // (lib.optionalAttrs stdenv.isDarwin appleGpuLibs))
