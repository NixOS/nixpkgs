{ lib
, buildGo122Module
, fetchFromGitHub
, fetchpatch
, buildEnv
, linkFarm
, overrideCC
, makeWrapper
, stdenv
, nixosTests

, pkgs
, cmake
, gcc12
, clblast
, libdrm
, rocmPackages
, cudaPackages
, linuxPackages
, darwin

  # one of `[ null "rocm" "cuda" ]`
, acceleration ? null

, testers
, ollama
}:

let
  pname = "ollama";
  version = "0.1.29";
  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-M2G53DJF/22ZVCAb4jGjyErKO6q2argehHSV7AEef6w=";
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
      rocmPackages.clr
      rocmPackages.hipblas
      rocmPackages.rocblas
      rocmPackages.rocsolver
      rocmPackages.rocsparse
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
      buildGo122Module.override { stdenv = overrideCC stdenv gcc12; }
    else
      buildGo122Module;
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
  vendorHash = "sha256-Lj7CBvS51RqF63c01cOCgY7BCQeCKGu794qzb/S80C0=";

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
    (preparePatch "01-cache.diff" "sha256-VDwu/iK6taBCyscpndQiOJ3eGqonnLVwmS2rJNMBVGU=")
    (preparePatch "02-cudaleaks.diff" "sha256-nxsWgrePUMsZBWWQAjqVHWMJPzr1owH1zSJvUU7Q5pA=")
    (preparePatch "03-load_exception.diff" "sha256-1DfNahFYYxqlx4E4pwMKQpL+XR0bibYnDFGt6dCL4TM=")
    (preparePatch "04-locale.diff" "sha256-r5nHiP6yN/rQObRu2FZIPBKpKP9yByyZ6sSI2SKj6Do=")
    (preparePatch "05-fix-clip-free.diff" "sha256-EFZ+QTtZCvstVxYgVdFKHsQqdkL98T0eXOEBOqCrlL4=")
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
  postFixup = ''
    # the app doesn't appear functional at the moment, so hide it
    mv "$out/bin/app" "$out/bin/.ollama-app"
  '' + lib.optionalString (enableRocm || enableCuda) ''
    # expose runtime libraries necessary to use the gpu
    mv "$out/bin/ollama" "$out/bin/.ollama-unwrapped"
    makeWrapper "$out/bin/.ollama-unwrapped" "$out/bin/ollama" \
      --suffix LD_LIBRARY_PATH : '/run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}' '' + lib.optionalString enableRocm ''\
      --set-default HIP_PATH ${rocmPath}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jmorganca/ollama/version.Version=${version}"
    "-X=github.com/jmorganca/ollama/server.mode=release"
  ];

  passthru.tests = {
    service = nixosTests.ollama;
    rocm = pkgs.ollama.override { acceleration = "rocm"; };
    cuda = pkgs.ollama.override { acceleration = "cuda"; };
    version = testers.testVersion {
      inherit version;
      package = ollama;
    };
  };

  meta = {
    changelog = "https://github.com/ollama/ollama/releases/tag/v${version}";
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "ollama";
    maintainers = with maintainers; [ abysssol dit7ya elohmeier ];
  };
})
