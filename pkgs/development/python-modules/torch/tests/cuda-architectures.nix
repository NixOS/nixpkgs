{
  lib,
  callPackage,
  runCommand,
  cmake,
  cudaPackages,
  src,
}:
let
  # Exercise the recipe's default selection without building another Torch.
  mixed = callPackage ../source {
    cudaSupport = true;
    gpuTargets = [ ];
    cudaPackages = cudaPackages.overrideScope (
      _: prev: {
        flags = prev.flags // {
          cudaCapabilities = [
            "8.9"
            "10.0f"
          ];
        };
      }
    );
  };
  explicit = mixed.override { gpuTargets = [ "8.9+PTX" ]; };
in
assert
  mixed.cudaCapabilities == [
    "8.9"
    "10.0f"
  ];
assert mixed.gpuTargetString == "8.9;10.0f";
assert lib.hasInfix ''export TORCH_CUDA_ARCH_LIST="8.9;10.0f"'' mixed.preConfigure;
assert explicit.gpuTargetString == "8.9+PTX";
runCommand "torch-cuda-architectures"
  {
    nativeBuildInputs = [
      cmake
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_cuobjdump
    ];
    strictDeps = true;
  }
  ''
    cat > architectures.cmake <<'EOF'
    set(CUDA_VERSION "${cudaPackages.cudaMajorMinorVersion}")
    include("${src}/cmake/Modules_CUDA_fix/upstream/FindCUDA/select_compute_arch.cmake")
    CUDA_SELECT_NVCC_ARCH_FLAGS(flags "$ENV{TORCH_CUDA_ARCH_LIST}")
    list(JOIN flags "\n" flags)
    file(WRITE flags.rsp "''${flags}\n")
    EOF
    echo 'extern "C" __global__ void kernel() {}' > kernel.cu

    export TORCH_CUDA_ARCH_LIST=${lib.escapeShellArg mixed.gpuTargetString}
    cmake -P architectures.cmake
    nvcc --fatbin --options-file flags.rsp kernel.cu -o mixed.fatbin
    cuobjdump --dump-elf mixed.fatbin > mixed.elf
    grep -Fx 'arch = sm_89' mixed.elf
    grep -Fx 'arch = sm_100f' mixed.elf

    export TORCH_CUDA_ARCH_LIST=${lib.escapeShellArg explicit.gpuTargetString}
    cmake -P architectures.cmake
    nvcc --fatbin --options-file flags.rsp kernel.cu -o explicit.fatbin
    cuobjdump --list-ptx explicit.fatbin > explicit.list
    grep -F 'sm_89' explicit.list

    export TORCH_CUDA_ARCH_LIST=not-an-architecture
    if cmake -P architectures.cmake > malformed.log 2>&1; then
      echo 'CMake accepted a malformed architecture' >&2
      exit 1
    fi
    grep -F 'Unknown CUDA Architecture Name' malformed.log

    export TORCH_CUDA_ARCH_LIST=99.9
    cmake -P architectures.cmake
    if nvcc --fatbin --options-file flags.rsp kernel.cu -o unsupported.fatbin > unsupported.log 2>&1; then
      echo 'NVCC accepted an unsupported architecture' >&2
      exit 1
    fi
    grep -F "Unsupported gpu architecture 'compute_999'" unsupported.log
    mkdir -p "$out"
    cp mixed.{fatbin,elf} explicit.{fatbin,list} malformed.log unsupported.log "$out/"
  ''
