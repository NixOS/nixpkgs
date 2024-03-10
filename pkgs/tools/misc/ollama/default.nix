{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, buildEnv
, linkFarm
, overrideCC
, makeWrapper
, stdenv

, pkgs
, cmake
, gcc11
, clblast
, libdrm
, rocmPackages
, cudaPackages
, linuxPackages
, darwin

  # one of `[ null "rocm" "cuda" ]`
, acceleration ? null
}:

let
  pname = "ollama";
  version = "0.1.28";
  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-8f7veZitorNiqGBPJuf/Y36TcFK8Q75Vw4w6CeTk8qs=";
    fetchSubmodules = true;
  };

  validAccel = lib.assertOneOf "ollama.acceleration" acceleration [ null "rocm" "cuda" ];

  warnIfNotLinux = api: (lib.warnIfNot stdenv.isLinux
    "building ollama with `${api}` is only supported on linux; falling back to cpu"
    stdenv.isLinux);
  enableRocm = validAccel && (acceleration == "rocm") && (warnIfNotLinux "rocm");
  enableCuda = validAccel && (acceleration == "cuda") && (warnIfNotLinux "cuda");

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

  cudaToolkit = buildEnv {
    name = "cuda-toolkit";
    ignoreCollisions = true; # FIXME: find a cleaner way to do this without ignoring collisions
    paths = [
      cudaPackages.cudatoolkit
      cudaPackages.cuda_cudart
    ];
    postBuild = ''
      rm "$out/lib64"
      ln -s "lib" "$out/lib64"

      ln -s "stubs/libcuda.so" "$out/lib/libcuda.so"
      ln -s "stubs/libcuda.so" "$out/lib/libcuda.so.1"
    '';
  };

  runtimeLibs = lib.optionals enableRocm [
    rocmPackages.rocm-smi
  ] ++ lib.optionals enableCuda [
    linuxPackages.nvidia_x11
  ];

  appleFrameworks = darwin.apple_sdk_11_0.frameworks;
  metalFrameworks = [
    appleFrameworks.Accelerate
    appleFrameworks.Metal
    appleFrameworks.MetalKit
    appleFrameworks.MetalPerformanceShaders
  ];


  goBuild =
    if enableCuda then
      buildGoModule.override { stdenv = overrideCC stdenv gcc11; }
    else
      buildGoModule;
  preparePatch = patch: hash: fetchpatch {
    url = "file://${src}/llm/patches/${patch}";
    inherit hash;
    stripLen = 1;
    extraPrefix = "llm/llama.cpp/";
  };
  inherit (lib) licenses platforms maintainers;
in
goBuild ((lib.optionalAttrs enableRocm {
  ROCM_PATH = rocmPath;
  CLBlast_DIR = "${clblast}/lib/cmake/CLBlast";
}) // (lib.optionalAttrs enableCuda {
  CUDA_LIB_DIR = "${cudaToolkit}/lib";
  CUDACXX = "${cudaToolkit}/bin/nvcc";
  CUDAToolkit_ROOT = cudaToolkit;
}) // {
  inherit pname version src;
  vendorHash = "sha256-DPIhDqE/yXpSQqrx07osMBMafK61yU2dl4cZhxSTvm8=";

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals (enableRocm || enableCuda) [
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin
    metalFrameworks;

  buildInputs = lib.optionals enableRocm [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.rocblas
    rocmPackages.rocsolver
    rocmPackages.rocsparse
    libdrm
  ] ++ lib.optionals enableCuda [
    cudaPackages.cuda_cudart
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
      --replace 'int main(' 'int __main('
    # replace inaccurate version number with actual release version
    substituteInPlace version/version.go --replace 0.0.0 '${version}'
  '';
  preBuild = ''
    export OLLAMA_SKIP_PATCHING=true
    # build llama.cpp libraries for ollama
    go generate ./...
  '';
  postFixup = ''
    # the app doesn't appear functional at the moment, so hide it
    mv "$out/bin/app" "$out/bin/.ollama-app"
  '' + lib.optionalString (enableRocm || enableCuda) ''
    # expose runtime libraries necessary to use the gpu
    mv "$out/bin/ollama" "$out/bin/.ollama-unwrapped"
    makeWrapper "$out/bin/.ollama-unwrapped" "$out/bin/ollama" \
      --suffix LD_LIBRARY_PATH : '/run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jmorganca/ollama/version.Version=${version}"
    "-X=github.com/jmorganca/ollama/server.mode=release"
  ];

  # for now, just test that rocm and cuda build
  passthru.tests = lib.optionalAttrs stdenv.isLinux {
    rocm = pkgs.ollama.override { acceleration = "rocm"; };
    cuda = pkgs.ollama.override { acceleration = "cuda"; };
  };

  meta = {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "ollama";
    maintainers = with maintainers; [ abysssol dit7ya elohmeier ];
  };
})
