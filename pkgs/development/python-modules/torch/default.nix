{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  buildPythonPackage,
  python,
  runCommand,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  autoAddDriverRunpath,
  effectiveMagma ?
    if cudaSupport then
      magma-cuda-static
    else if rocmSupport then
      magma-hip
    else
      magma,
  magma,
  magma-hip,
  magma-cuda-static,
  # Use the system NCCL as long as we're targeting CUDA on a supported platform.
  useSystemNccl ? (cudaSupport && !cudaPackages.nccl.meta.unsupported || rocmSupport),
  MPISupport ? false,
  mpi,
  buildDocs ? false,

  # tests.cudaAvailable:
  callPackage,

  # Native build inputs
  cmake,
  symlinkJoin,
  which,
  pybind11,
  removeReferencesTo,

  # Build inputs
  numactl,
  Accelerate,
  CoreServices,
  libobjc,

  # Propagated build inputs
  astunparse,
  fsspec,
  filelock,
  jinja2,
  networkx,
  sympy,
  numpy,
  pyyaml,
  cffi,
  click,
  typing-extensions,
  # ROCm build and `torch.compile` requires `triton`
  tritonSupport ? (!stdenv.hostPlatform.isDarwin),
  triton,

  # Unit tests
  hypothesis,
  psutil,

  # Disable MKLDNN on aarch64-darwin, it negatively impacts performance,
  # this is also what official pytorch build does
  mklDnnSupport ? !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64),

  # virtual pkg that consistently instantiates blas across nixpkgs
  # See https://github.com/NixOS/nixpkgs/pull/83888
  blas,

  # ninja (https://ninja-build.org) must be available to run C++ extensions tests,
  ninja,

  # dependencies for torch.utils.tensorboard
  pillow,
  six,
  future,
  tensorboard,
  protobuf,

  pythonOlder,

  # ROCm dependencies
  rocmSupport ? config.rocmSupport,
  rocmPackages_5,
  gpuTargets ? [ ],
}:

let
  inherit (lib)
    attrsets
    lists
    strings
    trivial
    ;
  inherit (cudaPackages) cudaFlags cudnn nccl;

  rocmPackages = rocmPackages_5;

  setBool = v: if v then "1" else "0";

  # https://github.com/pytorch/pytorch/blob/v2.4.0/torch/utils/cpp_extension.py#L1953
  supportedTorchCudaCapabilities =
    let
      real = [
        "3.5"
        "3.7"
        "5.0"
        "5.2"
        "5.3"
        "6.0"
        "6.1"
        "6.2"
        "7.0"
        "7.2"
        "7.5"
        "8.0"
        "8.6"
        "8.7"
        "8.9"
        "9.0"
        "9.0a"
      ];
      ptx = lists.map (x: "${x}+PTX") real;
    in
    real ++ ptx;

  # NOTE: The lists.subtractLists function is perhaps a bit unintuitive. It subtracts the elements
  #   of the first list *from* the second list. That means:
  #   lists.subtractLists a b = b - a

  # For CUDA
  supportedCudaCapabilities = lists.intersectLists cudaFlags.cudaCapabilities supportedTorchCudaCapabilities;
  unsupportedCudaCapabilities = lists.subtractLists supportedCudaCapabilities cudaFlags.cudaCapabilities;

  # Use trivial.warnIf to print a warning if any unsupported GPU targets are specified.
  gpuArchWarner =
    supported: unsupported:
    trivial.throwIf (supported == [ ]) (
      "No supported GPU targets specified. Requested GPU targets: "
      + strings.concatStringsSep ", " unsupported
    ) supported;

  # Create the gpuTargetString.
  gpuTargetString = strings.concatStringsSep ";" (
    if gpuTargets != [ ] then
      # If gpuTargets is specified, it always takes priority.
      gpuTargets
    else if cudaSupport then
      gpuArchWarner supportedCudaCapabilities unsupportedCudaCapabilities
    else if rocmSupport then
      rocmPackages.clr.gpuTargets
    else
      throw "No GPU targets specified"
  );

  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths = with rocmPackages; [
      rocm-core
      clr
      rccl
      miopen
      miopengemm
      rocrand
      rocblas
      rocsparse
      hipsparse
      rocthrust
      rocprim
      hipcub
      roctracer
      rocfft
      rocsolver
      hipfft
      hipsolver
      hipblas
      rocminfo
      rocm-thunk
      rocm-comgr
      rocm-device-libs
      rocm-runtime
      clr.icd
      hipify
    ];

    # Fix `setuptools` not being found
    postBuild = ''
      rm -rf $out/nix-support
    '';
  };

  brokenConditions = attrsets.filterAttrs (_: cond: cond) {
    "CUDA and ROCm are mutually exclusive" = cudaSupport && rocmSupport;
    "CUDA is not targeting Linux" = cudaSupport && !stdenv.hostPlatform.isLinux;
    "Unsupported CUDA version" =
      cudaSupport
      && !(builtins.elem cudaPackages.cudaMajorVersion [
        "11"
        "12"
      ]);
    "MPI cudatoolkit does not match cudaPackages.cudatoolkit" =
      MPISupport && cudaSupport && (mpi.cudatoolkit != cudaPackages.cudatoolkit);
    # This used to be a deep package set comparison between cudaPackages and
    # effectiveMagma.cudaPackages, making torch too strict in cudaPackages.
    # In particular, this triggered warnings from cuda's `aliases.nix`
    "Magma cudaPackages does not match cudaPackages" =
      cudaSupport && (effectiveMagma.cudaPackages.cudaVersion != cudaPackages.cudaVersion);
    "Rocm support is currently broken because `rocmPackages.hipblaslt` is unpackaged. (2024-06-09)" =
      rocmSupport;
  };
in
buildPythonPackage rec {
  pname = "torch";
  # Don't forget to update torch-bin to the same version.
  version = "2.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8.0";

  outputs = [
    "out" # output standard python package
    "dev" # output libtorch headers
    "lib" # output libtorch libraries
    "cxxdev" # propagated deps for the cmake consumers of torch
  ];
  cudaPropagateToOutput = "cxxdev";

  # the following expression has been generated using
  # https://codeberg.org/gm6k/git-unroll
  src =
    assert version == "2.4.1";
    (rec {
      src_DCGM = fetchFromGitHub {
        owner = "NVIDIA";
        repo = "DCGM";
        rev = "ffde4e54bc7249a6039a5e6b45b395141e1217f9";
        hash = "sha256-jlnq25byEep7wRF3luOIGaiaYjqSVaTBx02N6gE/ox8=";
      };
      src_FP16 = fetchFromGitHub {
        owner = "Maratyszcza";
        repo = "FP16";
        rev = "4dfe081cf6bcd15db339cf2680b9281b8451eeb3";
        hash = "sha256-B27LtVnL52niaFgPW0pp5Uulub/Q3NvtSDkJNahrSBk=";
      };
      src_FXdiv = fetchFromGitHub {
        owner = "Maratyszcza";
        repo = "FXdiv";
        rev = "b408327ac2a15ec3e43352421954f5b1967701d1";
        hash = "sha256-BEjscsejYVhRxDAmah5DT3+bglp8G5wUTTYL7+HjWds=";
      };
      src_GSL = fetchFromGitHub {
        owner = "microsoft";
        repo = "GSL";
        rev = "6f4529395c5b7c2d661812257cd6780c67e54afa";
        hash = "sha256-sNTDH1ohz+rcnBvA5KkarHKdRMQPW0c2LeSVPdEYx6Q=";
      };
      src_NNPACK = fetchFromGitHub {
        owner = "Maratyszcza";
        repo = "NNPACK";
        rev = "c07e3a0400713d546e0dea2d5466dd22ea389c73";
        hash = "sha256-GzF53u1ELtmEH3WbBzGBemlQhjj3EIKB+37wMtSYE2g=";
      };
      src_PeachPy = fetchFromGitHub {
        owner = "malfet";
        repo = "PeachPy";
        rev = "f45429b087dd7d5bc78bb40dc7cf06425c252d67";
        hash = "sha256-eyhfnOOZPtsJwjkF6ybv3F77fyjaV6wzgu+LxadZVw0=";
      };
      src_VulkanMemoryAllocator = fetchFromGitHub {
        owner = "GPUOpen-LibrariesAndSDKs";
        repo = "VulkanMemoryAllocator";
        rev = "a6bfc237255a6bac1513f7c1ebde6d8aed6b5191";
        hash = "sha256-urUebQaPTgCECmm4Espri1HqYGy0ueAqTBu/VSiX/8I=";
      };
      src_XNNPACK = fetchFromGitHub {
        owner = "google";
        repo = "XNNPACK";
        rev = "fcbf55af6cf28a4627bcd1f703ab7ad843f0f3a2";
        hash = "sha256-lnycZPoswZQwRWJjR4if4qp8O9KhgYNbtwjNuoem48w=";
      };
      src_asmjit = fetchFromGitHub {
        owner = "asmjit";
        repo = "asmjit";
        rev = "d3fbf7c9bc7c1d1365a94a45614b91c5a3706b81";
        hash = "sha256-0Wv9dxrh9GfajTFb+NpguqqSWH0mqJAj03bxFVJbft8=";
      };
      src_benchmark = fetchFromGitHub {
        owner = "google";
        repo = "benchmark";
        rev = "0d98dba29d66e93259db7daa53a9327df767a415";
        hash = "sha256-yUiFxi80FWBmTZgqmqTMf9oqcBeg3o4I4vKd4djyRWY=";
      };
      src_benchmark_onnx = fetchFromGitHub {
        owner = "google";
        repo = "benchmark";
        rev = "2dd015dfef425c866d9a43f2c67d8b52d709acb6";
        hash = "sha256-pUW9YVaujs/y00/SiPqDgK4wvVsaM7QUp/65k0t7Yr0=";
      };
      src_benchmark_opentelemetry-cpp = fetchFromGitHub {
        owner = "google";
        repo = "benchmark";
        rev = "d572f4777349d43653b21d6c2fc63020ab326db2";
        hash = "sha256-gg3g/0Ki29FnGqKv9lDTs5oA9NjH23qQ+hTdVtSU+zo=";
      };
      src_benchmark_protobuf = fetchFromGitHub {
        owner = "google";
        repo = "benchmark";
        rev = "5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8";
        hash = "sha256-iFRgjLkftuszAqBnmS9GXU8BwYnabmwMAQyw19sfjb4=";
      };
      src_civetweb = fetchFromGitHub {
        owner = "civetweb";
        repo = "civetweb";
        rev = "eefb26f82b233268fc98577d265352720d477ba4";
        hash = "sha256-Qh6BGPk7a01YzCeX42+Og9M+fjXRs7kzNUCyT4mYab4=";
      };
      src_clang-cindex-python3 = fetchFromGitHub {
        owner = "wjakob";
        repo = "clang-cindex-python3";
        rev = "6a00cbc4a9b8e68b71caf7f774b3f9c753ae84d5";
        hash = "sha256-IDUIuAvgCzWaHoTJUZrH15bqoVcP8bZk+Gs1Ae6/CpY=";
      };
      src_cpp-httplib = fetchFromGitHub {
        owner = "yhirose";
        repo = "cpp-httplib";
        rev = "3b6597bba913d51161383657829b7e644e59c006";
        hash = "sha256-dd9NckF1mGhQOyV1LO07QyP51l1kSpYQOH0GkG4v2eE=";
      };
      src_cpr = fetchFromGitHub {
        owner = "libcpr";
        repo = "cpr";
        rev = "871ed52d350214a034f6ef8a3b8f51c5ce1bd400";
        hash = "sha256-TxoDCIa7pS+nfI8hNiGIRQKpYNrKSd1yCXPfVXPcRW8=";
      };
      src_cpuinfo = fetchFromGitHub {
        owner = "pytorch";
        repo = "cpuinfo";
        rev = "d6860c477c99f1fce9e28eb206891af3c0e1a1d7";
        hash = "sha256-GmzkmdrrEcpAbmAYRfPrG1ByNqSe/s/Vx01v2h3/92E=";
      };
      src_cpuinfo_fbgemm = fetchFromGitHub {
        owner = "pytorch";
        repo = "cpuinfo";
        rev = "ed8b86a253800bafdb7b25c5c399f91bff9cb1f3";
        hash = "sha256-YRqBU83AjxbSE5zquhi4iIiJna/qFWA0jo2GBifqzi8=";
      };
      src_cudnn-frontend = fetchFromGitHub {
        owner = "NVIDIA";
        repo = "cudnn-frontend";
        rev = "b740542818f36857acf7f9853f749bbad4118c65";
        hash = "sha256-F4TDT//v2YA/VhhaIpV7NWBzVK697snAFU1RgBlU4yM=";
      };
      src_cutlass = fetchFromGitHub {
        owner = "NVIDIA";
        repo = "cutlass";
        rev = "bbe579a9e3beb6ea6626d9227ec32d0dae119a49";
        hash = "sha256-81O80F3MMOn22N9UaXLU6/9DTVWenYvKhLTHoxw8EEU=";
      };
      src_cutlass_fbgemm = fetchFromGitHub {
        owner = "NVIDIA";
        repo = "cutlass";
        rev = "fc9ebc645b63f3a6bc80aaefde5c063fb72110d6";
        hash = "sha256-e2SwXNNwjl/1fV64b+mOJvwGDYeO1LFcqZGbNten37U=";
      };
      src_dynolog = fetchFromGitHub {
        owner = "facebookincubator";
        repo = "dynolog";
        rev = "7d04a0053a845370ae06ce317a22a48e9edcc74e";
        hash = "sha256-Je6wAz+uJ/AiAnSZVQ4+pGajZ8DymS0qI9ekB8fGYOo=";
      };
      src_eigen = fetchFromGitLab {
        domain = "gitlab.com";
        owner = "libeigen";
        repo = "eigen";
        rev = "3147391d946bb4b6c68edd901f2add6ac1f31f8c";
        hash = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
      };
      src_fbgemm = fetchFromGitHub {
        owner = "pytorch";
        repo = "fbgemm";
        rev = "dbc3157bf256f1339b3fa1fef2be89ac4078be0e";
        hash = "sha256-PJiFtLnPA6IgxZ2sXIcyyjFRGtb+sG5y2hiWEwFuBOU=";
      };
      src_fbjni = fetchFromGitHub {
        owner = "facebookincubator";
        repo = "fbjni";
        rev = "7e1e1fe3858c63c251c637ae41a20de425dde96f";
        hash = "sha256-PsgUHtCE3dNR2QdUnRjrXb0ZKZNGwFkA8RWYkZEklEY=";
      };
      src_flatbuffers = fetchFromGitHub {
        owner = "google";
        repo = "flatbuffers";
        rev = "01834de25e4bf3975a9a00e816292b1ad0fe184b";
        hash = "sha256-h0lF7jf1cDVVyqhUCi7D0NoZ3b4X/vWXsFplND80lGs=";
      };
      src_fmt = fetchFromGitHub {
        owner = "fmtlib";
        repo = "fmt";
        rev = "e69e5f977d458f2650bb346dadf2ad30c5320281";
        hash = "sha256-pEltGLAHLZ3xypD/Ur4dWPWJ9BGVXwqQyKcDWVmC3co=";
      };
      src_fmt_dynolog = fetchFromGitHub {
        owner = "fmtlib";
        repo = "fmt";
        rev = "cd4af11efc9c622896a3e4cb599fa28668ca3d05";
        hash = "sha256-Ks3UG3V0Pz6qkKYFhy71ZYlZ9CPijO6GBrfMqX5zAp8=";
      };
      src_fmt_kineto = fetchFromGitHub {
        owner = "fmtlib";
        repo = "fmt";
        rev = "a33701196adfad74917046096bf5a2aa0ab0bb50";
        hash = "sha256-rP6ymyRc7LnKxUXwPpzhHOQvpJkpnRFOt2ctvUNlYI0=";
      };
      src_foxi = fetchFromGitHub {
        owner = "houseroad";
        repo = "foxi";
        rev = "c278588e34e535f0bb8f00df3880d26928038cad";
        hash = "sha256-quDHW0kgp6w9sjcbvjxU9/2tllTW1oM6d3zXCkvVemA=";
      };
      src_gemmlowp = fetchFromGitHub {
        owner = "google";
        repo = "gemmlowp";
        rev = "3fb5c176c17c765a3492cd2f0321b0dab712f350";
        hash = "sha256-G3PAf9j7Tb4dUoaV9Tmxkkfu3v+w0uFbZ+MWS68tlRw=";
      };
      src_gflags = fetchFromGitHub {
        owner = "gflags";
        repo = "gflags";
        rev = "e171aa2d15ed9eb17054558e0b3a6a413bb01067";
        hash = "sha256-4NLd/p72H7ZiFCCVjTfM/rDvZ8CVPMxYpnJ2O1od8ZA=";
      };
      src_gflags_gflags = fetchFromGitHub {
        owner = "gflags";
        repo = "gflags";
        rev = "8411df715cf522606e3b1aca386ddfc0b63d34b4";
        hash = "sha256-Bb4g64u5a0QRWwDl1ryNXmht6NKFWPW9bAF07yYRJ6I=";
      };
      src_glog = fetchFromGitHub {
        owner = "google";
        repo = "glog";
        rev = "b33e3bad4c46c8a6345525fd822af355e5ef9446";
        hash = "sha256-xqRp9vaauBkKz2CXbh/Z4TWqhaUtqfbsSlbYZR/kW9s=";
      };
      src_gloo = fetchFromGitHub {
        owner = "facebookincubator";
        repo = "gloo";
        rev = "5354032ea08eadd7fc4456477f7f7c6308818509";
        hash = "sha256-JMLtxyQz7jechJ5DmMq0guOfL9leI6khdI9g/5Ckgfc=";
      };
      src_googletest = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "e2239ee6043f73722e7aa812a459f54a28552929";
        hash = "sha256-SjlJxushfry13RGA7BCjYC9oZqV4z6x8dOiHfl/wpF0=";
      };
      src_googletest_dynolog = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "58d77fa8070e8cec2dc1ed015d66b454c8d78850";
        hash = "sha256-W+OxRTVtemt2esw4P7IyGWXOonUN5ZuscjvzqkYvZbM=";
      };
      src_googletest_fbgemm = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "cbf019de22c8dd37b2108da35b2748fd702d1796";
        hash = "sha256-G6NihPly7czG2NOX66kFfcf5ya+XRrUWt4SP1Y9JPzs=";
      };
      src_googletest_kineto = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "7aca84427f224eeed3144123d5230d5871e93347";
        hash = "sha256-ML144v86Kb9KSyxpqn8+XdKeU8r53PiMyh2ZzNYDyZU=";
      };
      src_googletest_opentelemetry-cpp = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "b796f7d44681514f58a683a3a71ff17c94edb0c1";
        hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
      };
      src_googletest_protobuf = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081";
        hash = "sha256-Zh7t6kOabEZxIuTwREerNSgbZLPnGWv78h0wQQAIuT4=";
      };
      src_googletest_tensorpipe = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "aee0f9d9b5b87796ee8a0ab26b7587ec30e8858e";
        hash = "sha256-L2HR+QTQmagk92JiuW3TRx47so33xQvewdeYL1ipUPs=";
      };
      src_hipify_torch = fetchFromGitHub {
        owner = "ROCmSoftwarePlatform";
        repo = "hipify_torch";
        rev = "23f53b025b466d8ec3c45d52290d3442f7fbe6b1";
        hash = "sha256-ohbGKy0sxa5pQy9EwsZk2UWmjveCZaJu/PEK2MLbjII=";
      };
      src_ideep = fetchFromGitHub {
        owner = "intel";
        repo = "ideep";
        rev = "55ca0191687aaf19aca5cdb7881c791e3bea442b";
        hash = "sha256-Fx/VQCGohsVIrhV1O7fZDjAUddLr1nxs8vYizet2CkY=";
      };
      src_ittapi = fetchFromGitHub {
        owner = "intel";
        repo = "ittapi";
        rev = "5b8a7d7422611c3a0d799fb5fc5dd4abfae35b42";
        hash = "sha256-VxJky2TF3RcIMqjNaAK/mvpC0afkwpAsY0cD6Ergkls=";
      };
      src_json = fetchFromGitHub {
        owner = "nlohmann";
        repo = "json";
        rev = "87cda1d6646592ac5866dc703c8e1839046a6806";
        hash = "sha256-lXYJGWwLyQPqvxnDRWoDLXdjiD81r1eNHi7vRdbIuJ0=";
      };
      src_json_dynolog = fetchFromGitHub {
        owner = "nlohmann";
        repo = "json";
        rev = "4f8fba14066156b73f1189a2b8bd568bde5284c5";
        hash = "sha256-DTsZrdB9GcaNkx7ZKxcgCA3A9ShM5icSF0xyGguJNbk=";
      };
      src_json_opentelemetry-cpp = fetchFromGitHub {
        owner = "nlohmann";
        repo = "json";
        rev = "bc889afb4c5bf1c0d8ee29ef35eaaf4c8bef8a5d";
        hash = "sha256-SUdhIV7tjtacf5DkoWk9cnkfyMlrkg8ZU7XnPZd22Tw=";
      };
      src_kineto = fetchFromGitHub {
        owner = "pytorch";
        repo = "kineto";
        rev = "be1317644c68b4bfc4646024a6b221066e430031";
        hash = "sha256-6WZJ7gkzB5Z3ZkqfDt+ofxWUZ4DRkQII2uOhuUPysL4=";
      };
      src_libnop = fetchFromGitHub {
        owner = "google";
        repo = "libnop";
        rev = "910b55815be16109f04f4180e9adee14fb4ce281";
        hash = "sha256-AsPZt+ylfdGpytQ1RoQljKeXE2uGkGONCaWzLK2sZhA=";
      };
      src_libuv = fetchFromGitHub {
        owner = "libuv";
        repo = "libuv";
        rev = "1dff88e5161cba5c59276d2070d2e304e4dcb242";
        hash = "sha256-i6AYD1Ony0L2+3yWK6bxOfwoZEvd9qCg33QSqA7bRXI=";
      };
      src_mimalloc = fetchFromGitHub {
        owner = "microsoft";
        repo = "mimalloc";
        rev = "b66e3214d8a104669c2ec05ae91ebc26a8f5ab78";
        hash = "sha256-uwuqln08Hx1d2l7GNn8/8hzOA1Pmzob5g17XgFb+blg=";
      };
      src_mkl-dnn = fetchFromGitHub {
        owner = "intel";
        repo = "mkl-dnn";
        rev = "1137e04ec0b5251ca2b4400a4fd3c667ce843d67";
        hash = "sha256-ArIy8FTl9nPRp7Wt6aneKNCMUIrzsN19YKMPjH+W5j4=";
      };
      src_nccl = fetchFromGitHub {
        owner = "NVIDIA";
        repo = "nccl";
        rev = "48bb7fec7953112ff37499a272317f6663f8f600";
        hash = "sha256-ModIjD6RaRD/57a/PA1oTgYhZsAQPrrvhl5sNVXnO6c=";
      };
      src_onnx = fetchFromGitHub {
        owner = "onnx";
        repo = "onnx";
        rev = "990217f043af7222348ca8f0301e17fa7b841781";
        hash = "sha256-mgYrY3IXUMgG/2/SjwMWAX0FneY+E8SpLDMnB9EUbF4=";
      };
      src_opentelemetry-cpp = fetchFromGitHub {
        owner = "open-telemetry";
        repo = "opentelemetry-cpp";
        rev = "a799f4aed9c94b765dcdaabaeab7d5e7e2310878";
        hash = "sha256-jLRUpB9aDvxsc7B42b08vN2rygN/ycgOyt78i2Hms0Q=";
      };
      src_opentelemetry-proto = fetchFromGitHub {
        owner = "open-telemetry";
        repo = "opentelemetry-proto";
        rev = "4ca4f0335c63cda7ab31ea7ed70d6553aee14dce";
        hash = "sha256-A14YrqvBAEBBPzvxcNVY2sJok+54/mHKNQPRaf9QLzs=";
      };
      src_opentracing-cpp = fetchFromGitHub {
        owner = "opentracing";
        repo = "opentracing-cpp";
        rev = "06b57f48ded1fa3bdd3d4346f6ef29e40e08eaf5";
        hash = "sha256-XlQi26ynXKDwA86DwsDw+hhKR8bcdnrtFH1CpAzVlLs=";
      };
      src_pfs = fetchFromGitHub {
        owner = "dtrugman";
        repo = "pfs";
        rev = "f68a2fa8ea36c783bdd760371411fcb495aa3150";
        hash = "sha256-VB7/7hi4vZKgpjpgir+CyWIMwoNLHGRIXPJvVOn8Pq4=";
      };
      src_pocketfft = fetchFromGitHub {
        owner = "mreineck";
        repo = "pocketfft";
        rev = "9d3ab05a7fffbc71a492bc6a17be034e83e8f0fe";
        hash = "sha256-RSbimayr8Np7YP0aUo1MNusFmhi9jjDfgGXbiISR+/8=";
      };
      src_prometheus-cpp = fetchFromGitHub {
        owner = "jupp0r";
        repo = "prometheus-cpp";
        rev = "c9ffcdda9086ffd9e1283ea7a0276d831f3c8a8d";
        hash = "sha256-qx6oBxd0YrUyFq+7ArnKBqOwrl5X8RS9nErhRDUJ7+8=";
      };
      src_protobuf = fetchFromGitHub {
        owner = "protocolbuffers";
        repo = "protobuf";
        rev = "d1eca4e4b421cd2997495c4b4e65cea6be4e9b8a";
        hash = "sha256-InCW/Sb4E7dQeg3VHgpCtm91qqfh0Qpmu4ZzKffacOQ=";
      };
      src_psimd = fetchFromGitHub {
        owner = "Maratyszcza";
        repo = "psimd";
        rev = "072586a71b55b7f8c584153d223e95687148a900";
        hash = "sha256-lV+VZi2b4SQlRYrhKx9Dxc6HlDEFz3newvcBjTekupo=";
      };
      src_pthreadpool = fetchFromGitHub {
        owner = "Maratyszcza";
        repo = "pthreadpool";
        rev = "4fe0e1e183925bf8cfa6aae24237e724a96479b8";
        hash = "sha256-R4YmNzWEELSkAws/ejmNVxqXDTJwcqjLU/o/HvgRn2E=";
      };
      src_pybind11 = fetchFromGitHub {
        owner = "pybind";
        repo = "pybind11";
        rev = "3e9dfa2866941655c56877882565e7577de6fc7b";
        hash = "sha256-DVkI5NxM5uME9m3PFYVpJOOa2j+yjL6AJn76fCTv2nE=";
      };
      src_pybind11_onnx = fetchFromGitHub {
        owner = "pybind";
        repo = "pybind11";
        rev = "5b0a6fc2017fcc176545afe3e09c9f9885283242";
        hash = "sha256-n7nLEG2+sSR9wnxM+C8FWc2B+Mx74Pan1+IQf+h2bGU=";
      };
      src_pybind11_tensorpipe = fetchFromGitHub {
        owner = "pybind";
        repo = "pybind11";
        rev = "a23996fce38ff6ccfbcdc09f1e63f2c4be5ea2ef";
        hash = "sha256-3TALLHJAeWCSf88oBgLyyUoI/HyWGasAcAy4fGOQt04=";
      };
      src_pytorch = fetchFromGitHub {
        owner = "pytorch";
        repo = "pytorch";
        rev = "v2.4.1";
        hash = "sha256-kzgNICQEm8vGQGuOsOZp40SXzB4vpqM5EWGEI1yEsmo=";
      };
      src_sleef = fetchFromGitHub {
        owner = "shibatch";
        repo = "sleef";
        rev = "60e76d2bce17d278b439d9da17177c8f957a9e9b";
        hash = "sha256-JfARLkdt4je8ll+oqPGJqzUCQbsXoJ0bbX3jf0aHd0o=";
      };
      src_tensorpipe = fetchFromGitHub {
        owner = "pytorch";
        repo = "tensorpipe";
        rev = "52791a2fd214b2a9dc5759d36725909c1daa7f2e";
        hash = "sha256-i+CtjNFPDUzFCPxP0//jMLJDrQoorg0On9NfoVaMUxI=";
      };
      src_vcpkg = fetchFromGitHub {
        owner = "Microsoft";
        repo = "vcpkg";
        rev = "8eb57355a4ffb410a2e94c07b4dca2dffbee8e50";
        hash = "sha256-u+4vyOphnowoaZgfkCbzF7Q4tuz2GN1bHylaKw352Lc=";
      };
      src_DCGM_recursive = src_DCGM;
      src_FP16_recursive = src_FP16;
      src_FXdiv_recursive = src_FXdiv;
      src_GSL_recursive = src_GSL;
      src_NNPACK_recursive = src_NNPACK;
      src_PeachPy_recursive = src_PeachPy;
      src_VulkanMemoryAllocator_recursive = src_VulkanMemoryAllocator;
      src_XNNPACK_recursive = src_XNNPACK;
      src_asmjit_recursive = src_asmjit;
      src_benchmark_recursive = src_benchmark;
      src_benchmark_onnx_recursive = src_benchmark_onnx;
      src_benchmark_opentelemetry-cpp_recursive = src_benchmark_opentelemetry-cpp;
      src_benchmark_protobuf_recursive = src_benchmark_protobuf;
      src_civetweb_recursive = src_civetweb;
      src_clang-cindex-python3_recursive = src_clang-cindex-python3;
      src_cpp-httplib_recursive = src_cpp-httplib;
      src_cpr_recursive = src_cpr;
      src_cpuinfo_recursive = src_cpuinfo;
      src_cpuinfo_fbgemm_recursive = src_cpuinfo_fbgemm;
      src_cudnn-frontend_recursive = src_cudnn-frontend;
      src_cutlass_recursive = src_cutlass;
      src_cutlass_fbgemm_recursive = src_cutlass_fbgemm;
      src_dynolog_recursive = runCommand "dynolog" { } ''
        cp -r ${src_dynolog} $out
        chmod u+w $out/third_party/DCGM
        cp -r ${src_DCGM_recursive}/* $out/third_party/DCGM
        chmod u+w $out/third_party/cpr
        cp -r ${src_cpr_recursive}/* $out/third_party/cpr
        chmod u+w $out/third_party/fmt
        cp -r ${src_fmt_dynolog_recursive}/* $out/third_party/fmt
        chmod u+w $out/third_party/gflags
        cp -r ${src_gflags_recursive}/* $out/third_party/gflags
        chmod u+w $out/third_party/glog
        cp -r ${src_glog_recursive}/* $out/third_party/glog
        chmod u+w $out/third_party/googletest
        cp -r ${src_googletest_dynolog_recursive}/* $out/third_party/googletest
        chmod u+w $out/third_party/json
        cp -r ${src_json_dynolog_recursive}/* $out/third_party/json
        chmod u+w $out/third_party/pfs
        cp -r ${src_pfs_recursive}/* $out/third_party/pfs
      '';
      src_eigen_recursive = src_eigen;
      src_fbgemm_recursive = runCommand "fbgemm" { } ''
        cp -r ${src_fbgemm} $out
        chmod u+w $out/third_party/asmjit
        cp -r ${src_asmjit_recursive}/* $out/third_party/asmjit
        chmod u+w $out/third_party/cpuinfo
        cp -r ${src_cpuinfo_fbgemm_recursive}/* $out/third_party/cpuinfo
        chmod u+w $out/third_party/cutlass
        cp -r ${src_cutlass_fbgemm_recursive}/* $out/third_party/cutlass
        chmod u+w $out/third_party/googletest
        cp -r ${src_googletest_fbgemm_recursive}/* $out/third_party/googletest
        chmod u+w $out/third_party/hipify_torch
        cp -r ${src_hipify_torch_recursive}/* $out/third_party/hipify_torch
      '';
      src_fbjni_recursive = src_fbjni;
      src_flatbuffers_recursive = src_flatbuffers;
      src_fmt_recursive = src_fmt;
      src_fmt_dynolog_recursive = src_fmt_dynolog;
      src_fmt_kineto_recursive = src_fmt_kineto;
      src_foxi_recursive = src_foxi;
      src_gemmlowp_recursive = src_gemmlowp;
      src_gflags_recursive = runCommand "gflags" { } ''
        cp -r ${src_gflags} $out
        chmod u+w $out/doc
        cp -r ${src_gflags_gflags_recursive}/* $out/doc
      '';
      src_gflags_gflags_recursive = src_gflags_gflags;
      src_glog_recursive = src_glog;
      src_gloo_recursive = src_gloo;
      src_googletest_recursive = src_googletest;
      src_googletest_dynolog_recursive = src_googletest_dynolog;
      src_googletest_fbgemm_recursive = src_googletest_fbgemm;
      src_googletest_kineto_recursive = src_googletest_kineto;
      src_googletest_opentelemetry-cpp_recursive = src_googletest_opentelemetry-cpp;
      src_googletest_protobuf_recursive = src_googletest_protobuf;
      src_googletest_tensorpipe_recursive = src_googletest_tensorpipe;
      src_hipify_torch_recursive = src_hipify_torch;
      src_ideep_recursive = runCommand "ideep" { } ''
        cp -r ${src_ideep} $out
        chmod u+w $out/mkl-dnn
        cp -r ${src_mkl-dnn_recursive}/* $out/mkl-dnn
      '';
      src_ittapi_recursive = src_ittapi;
      src_json_recursive = src_json;
      src_json_dynolog_recursive = src_json_dynolog;
      src_json_opentelemetry-cpp_recursive = src_json_opentelemetry-cpp;
      src_kineto_recursive = runCommand "kineto" { } ''
        cp -r ${src_kineto} $out
        chmod u+w $out/libkineto/third_party/dynolog
        cp -r ${src_dynolog_recursive}/* $out/libkineto/third_party/dynolog
        chmod u+w $out/libkineto/third_party/fmt
        cp -r ${src_fmt_kineto_recursive}/* $out/libkineto/third_party/fmt
        chmod u+w $out/libkineto/third_party/googletest
        cp -r ${src_googletest_kineto_recursive}/* $out/libkineto/third_party/googletest
      '';
      src_libnop_recursive = src_libnop;
      src_libuv_recursive = src_libuv;
      src_mimalloc_recursive = src_mimalloc;
      src_mkl-dnn_recursive = src_mkl-dnn;
      src_nccl_recursive = src_nccl;
      src_onnx_recursive = runCommand "onnx" { } ''
        cp -r ${src_onnx} $out
        chmod u+w $out/third_party/benchmark
        cp -r ${src_benchmark_onnx_recursive}/* $out/third_party/benchmark
        chmod u+w $out/third_party/pybind11
        cp -r ${src_pybind11_onnx_recursive}/* $out/third_party/pybind11
      '';
      src_opentelemetry-cpp_recursive = runCommand "opentelemetry-cpp" { } ''
        cp -r ${src_opentelemetry-cpp} $out
        chmod u+w $out/third_party/benchmark
        cp -r ${src_benchmark_opentelemetry-cpp_recursive}/* $out/third_party/benchmark
        chmod u+w $out/third_party/googletest
        cp -r ${src_googletest_opentelemetry-cpp_recursive}/* $out/third_party/googletest
        chmod u+w $out/third_party/ms-gsl
        cp -r ${src_GSL_recursive}/* $out/third_party/ms-gsl
        chmod u+w $out/third_party/nlohmann-json
        cp -r ${src_json_opentelemetry-cpp_recursive}/* $out/third_party/nlohmann-json
        chmod u+w $out/third_party/opentelemetry-proto
        cp -r ${src_opentelemetry-proto_recursive}/* $out/third_party/opentelemetry-proto
        chmod u+w $out/third_party/opentracing-cpp
        cp -r ${src_opentracing-cpp_recursive}/* $out/third_party/opentracing-cpp
        chmod u+w $out/third_party/prometheus-cpp
        cp -r ${src_prometheus-cpp_recursive}/* $out/third_party/prometheus-cpp
        chmod u+w $out/tools/vcpkg
        cp -r ${src_vcpkg_recursive}/* $out/tools/vcpkg
      '';
      src_opentelemetry-proto_recursive = src_opentelemetry-proto;
      src_opentracing-cpp_recursive = src_opentracing-cpp;
      src_pfs_recursive = src_pfs;
      src_pocketfft_recursive = src_pocketfft;
      src_prometheus-cpp_recursive = runCommand "prometheus-cpp" { } ''
        cp -r ${src_prometheus-cpp} $out
        chmod u+w $out/3rdparty/civetweb
        cp -r ${src_civetweb_recursive}/* $out/3rdparty/civetweb
        chmod u+w $out/3rdparty/googletest
        cp -r ${src_googletest_recursive}/* $out/3rdparty/googletest
      '';
      src_protobuf_recursive = runCommand "protobuf" { } ''
        cp -r ${src_protobuf} $out
        chmod u+w $out/third_party/benchmark
        cp -r ${src_benchmark_protobuf_recursive}/* $out/third_party/benchmark
        chmod u+w $out/third_party/googletest
        cp -r ${src_googletest_protobuf_recursive}/* $out/third_party/googletest
      '';
      src_psimd_recursive = src_psimd;
      src_pthreadpool_recursive = src_pthreadpool;
      src_pybind11_recursive = src_pybind11;
      src_pybind11_onnx_recursive = src_pybind11_onnx;
      src_pybind11_tensorpipe_recursive = runCommand "pybind11_tensorpipe" { } ''
        cp -r ${src_pybind11_tensorpipe} $out
        chmod u+w $out/tools/clang
        cp -r ${src_clang-cindex-python3_recursive}/* $out/tools/clang
      '';
      src_pytorch_recursive = runCommand "pytorch" { } ''
        cp -r ${src_pytorch} $out
        chmod u+w $out/android/libs/fbjni
        cp -r ${src_fbjni_recursive}/* $out/android/libs/fbjni
        chmod u+w $out/third_party/FP16
        cp -r ${src_FP16_recursive}/* $out/third_party/FP16
        chmod u+w $out/third_party/FXdiv
        cp -r ${src_FXdiv_recursive}/* $out/third_party/FXdiv
        chmod u+w $out/third_party/NNPACK
        cp -r ${src_NNPACK_recursive}/* $out/third_party/NNPACK
        chmod u+w $out/third_party/VulkanMemoryAllocator
        cp -r ${src_VulkanMemoryAllocator_recursive}/* $out/third_party/VulkanMemoryAllocator
        chmod u+w $out/third_party/XNNPACK
        cp -r ${src_XNNPACK_recursive}/* $out/third_party/XNNPACK
        chmod u+w $out/third_party/benchmark
        cp -r ${src_benchmark_recursive}/* $out/third_party/benchmark
        chmod u+w $out/third_party/cpp-httplib
        cp -r ${src_cpp-httplib_recursive}/* $out/third_party/cpp-httplib
        chmod u+w $out/third_party/cpuinfo
        cp -r ${src_cpuinfo_recursive}/* $out/third_party/cpuinfo
        chmod u+w $out/third_party/cudnn_frontend
        cp -r ${src_cudnn-frontend_recursive}/* $out/third_party/cudnn_frontend
        chmod u+w $out/third_party/cutlass
        cp -r ${src_cutlass_recursive}/* $out/third_party/cutlass
        chmod u+w $out/third_party/eigen
        cp -r ${src_eigen_recursive}/* $out/third_party/eigen
        chmod u+w $out/third_party/fbgemm
        cp -r ${src_fbgemm_recursive}/* $out/third_party/fbgemm
        chmod u+w $out/third_party/flatbuffers
        cp -r ${src_flatbuffers_recursive}/* $out/third_party/flatbuffers
        chmod u+w $out/third_party/fmt
        cp -r ${src_fmt_recursive}/* $out/third_party/fmt
        chmod u+w $out/third_party/foxi
        cp -r ${src_foxi_recursive}/* $out/third_party/foxi
        chmod u+w $out/third_party/gemmlowp/gemmlowp
        cp -r ${src_gemmlowp_recursive}/* $out/third_party/gemmlowp/gemmlowp
        chmod u+w $out/third_party/gloo
        cp -r ${src_gloo_recursive}/* $out/third_party/gloo
        chmod u+w $out/third_party/googletest
        cp -r ${src_googletest_recursive}/* $out/third_party/googletest
        chmod u+w $out/third_party/ideep
        cp -r ${src_ideep_recursive}/* $out/third_party/ideep
        chmod u+w $out/third_party/ittapi
        cp -r ${src_ittapi_recursive}/* $out/third_party/ittapi
        chmod u+w $out/third_party/kineto
        cp -r ${src_kineto_recursive}/* $out/third_party/kineto
        chmod u+w $out/third_party/mimalloc
        cp -r ${src_mimalloc_recursive}/* $out/third_party/mimalloc
        chmod u+w $out/third_party/nccl/nccl
        cp -r ${src_nccl_recursive}/* $out/third_party/nccl/nccl
        chmod u+w $out/third_party/nlohmann
        cp -r ${src_json_recursive}/* $out/third_party/nlohmann
        chmod u+w $out/third_party/onnx
        cp -r ${src_onnx_recursive}/* $out/third_party/onnx
        chmod u+w $out/third_party/opentelemetry-cpp
        cp -r ${src_opentelemetry-cpp_recursive}/* $out/third_party/opentelemetry-cpp
        chmod u+w $out/third_party/pocketfft
        cp -r ${src_pocketfft_recursive}/* $out/third_party/pocketfft
        chmod u+w $out/third_party/protobuf
        cp -r ${src_protobuf_recursive}/* $out/third_party/protobuf
        chmod u+w $out/third_party/psimd
        cp -r ${src_psimd_recursive}/* $out/third_party/psimd
        chmod u+w $out/third_party/pthreadpool
        cp -r ${src_pthreadpool_recursive}/* $out/third_party/pthreadpool
        chmod u+w $out/third_party/pybind11
        cp -r ${src_pybind11_recursive}/* $out/third_party/pybind11
        chmod u+w $out/third_party/python-peachpy
        cp -r ${src_PeachPy_recursive}/* $out/third_party/python-peachpy
        chmod u+w $out/third_party/sleef
        cp -r ${src_sleef_recursive}/* $out/third_party/sleef
        chmod u+w $out/third_party/tensorpipe
        cp -r ${src_tensorpipe_recursive}/* $out/third_party/tensorpipe
      '';
      src_sleef_recursive = src_sleef;
      src_tensorpipe_recursive = runCommand "tensorpipe" { } ''
        cp -r ${src_tensorpipe} $out
        chmod u+w $out/third_party/googletest
        cp -r ${src_googletest_tensorpipe_recursive}/* $out/third_party/googletest
        chmod u+w $out/third_party/libnop
        cp -r ${src_libnop_recursive}/* $out/third_party/libnop
        chmod u+w $out/third_party/libuv
        cp -r ${src_libuv_recursive}/* $out/third_party/libuv
        chmod u+w $out/third_party/pybind11
        cp -r ${src_pybind11_tensorpipe_recursive}/* $out/third_party/pybind11
      '';
      src_vcpkg_recursive = src_vcpkg;
    }).src_pytorch_recursive;

  patches =
    [
      # Allow setting PYTHON_LIB_REL_PATH with an environment variable.
      # https://github.com/pytorch/pytorch/pull/128419
      ./passthrough-python-lib-rel-path.patch
    ]
    ++ lib.optionals cudaSupport [ ./fix-cmake-cuda-toolkit.patch ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # pthreadpool added support for Grand Central Dispatch in April
      # 2020. However, this relies on functionality (DISPATCH_APPLY_AUTO)
      # that is available starting with macOS 10.13. However, our current
      # base is 10.12. Until we upgrade, we can fall back on the older
      # pthread support.
      ./pthreadpool-disable-gcd.diff
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # Propagate CUPTI to Kineto by overriding the search path with environment variables.
      # https://github.com/pytorch/pytorch/pull/108847
      ./pytorch-pr-108847.patch
    ];

  postPatch =
    lib.optionalString rocmSupport ''
      # https://github.com/facebookincubator/gloo/pull/297
      substituteInPlace third_party/gloo/cmake/Hipify.cmake \
        --replace "\''${HIPIFY_COMMAND}" "python \''${HIPIFY_COMMAND}"

      # Replace hard-coded rocm paths
      substituteInPlace caffe2/CMakeLists.txt \
        --replace "/opt/rocm" "${rocmtoolkit_joined}" \
        --replace "hcc/include" "hip/include" \
        --replace "rocblas/include" "include/rocblas" \
        --replace "hipsparse/include" "include/hipsparse"

      # Doesn't pick up the environment variable?
      substituteInPlace third_party/kineto/libkineto/CMakeLists.txt \
        --replace "\''$ENV{ROCM_SOURCE_DIR}" "${rocmtoolkit_joined}" \
        --replace "/opt/rocm" "${rocmtoolkit_joined}"

      # Strangely, this is never set in cmake
      substituteInPlace cmake/public/LoadHIP.cmake \
        --replace "set(ROCM_PATH \$ENV{ROCM_PATH})" \
          "set(ROCM_PATH \$ENV{ROCM_PATH})''\nset(ROCM_VERSION ${lib.concatStrings (lib.intersperse "0" (lib.splitVersion rocmPackages.clr.version))})"
    ''
    # Detection of NCCL version doesn't work particularly well when using the static binary.
    + lib.optionalString cudaSupport ''
      substituteInPlace cmake/Modules/FindNCCL.cmake \
        --replace \
          'message(FATAL_ERROR "Found NCCL header version and library version' \
          'message(WARNING "Found NCCL header version and library version'
    ''
    # Remove PyTorch's FindCUDAToolkit.cmake and use CMake's default.
    # NOTE: Parts of pytorch rely on unmaintained FindCUDA.cmake with custom patches to support e.g.
    # newer architectures (sm_90a). We do want to delete vendored patches, but have to keep them
    # until https://github.com/pytorch/pytorch/issues/76082 is addressed
    + lib.optionalString cudaSupport ''
      rm cmake/Modules/FindCUDAToolkit.cmake
    ''
    # error: no member named 'aligned_alloc' in the global namespace; did you mean simply 'aligned_alloc'
    # This lib overrided aligned_alloc hence the error message. Tltr: his function is linkable but not in header.
    +
      lib.optionalString
        (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0")
        ''
          substituteInPlace third_party/pocketfft/pocketfft_hdronly.h --replace-fail '#if (__cplusplus >= 201703L) && (!defined(__MINGW32__)) && (!defined(_MSC_VER))
          inline void *aligned_alloc(size_t align, size_t size)' '#if 0
          inline void *aligned_alloc(size_t align, size_t size)'
        '';

  # NOTE(@connorbaker): Though we do not disable Gloo or MPI when building with CUDA support, caution should be taken
  # when using the different backends. Gloo's GPU support isn't great, and MPI and CUDA can't be used at the same time
  # without extreme care to ensure they don't lock each other out of shared resources.
  # For more, see https://github.com/open-mpi/ompi/issues/7733#issuecomment-629806195.
  preConfigure =
    lib.optionalString cudaSupport ''
      export TORCH_CUDA_ARCH_LIST="${gpuTargetString}"
      export CUPTI_INCLUDE_DIR=${lib.getDev cudaPackages.cuda_cupti}/include
      export CUPTI_LIBRARY_DIR=${lib.getLib cudaPackages.cuda_cupti}/lib
    ''
    + lib.optionalString (cudaSupport && cudaPackages ? cudnn) ''
      export CUDNN_INCLUDE_DIR=${lib.getLib cudnn}/include
      export CUDNN_LIB_DIR=${cudnn.lib}/lib
    ''
    + lib.optionalString rocmSupport ''
      export ROCM_PATH=${rocmtoolkit_joined}
      export ROCM_SOURCE_DIR=${rocmtoolkit_joined}
      export PYTORCH_ROCM_ARCH="${gpuTargetString}"
      export CMAKE_CXX_FLAGS="-I${rocmtoolkit_joined}/include -I${rocmtoolkit_joined}/include/rocblas"
      python tools/amd_build/build_amd.py
    '';

  # Use pytorch's custom configurations
  dontUseCmakeConfigure = true;

  # causes possible redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  BUILD_NAMEDTENSOR = setBool true;
  BUILD_DOCS = setBool buildDocs;

  # We only do an imports check, so do not build tests either.
  BUILD_TEST = setBool false;

  # Unlike MKL, oneDNN (née MKLDNN) is FOSS, so we enable support for
  # it by default. PyTorch currently uses its own vendored version
  # of oneDNN through Intel iDeep.
  USE_MKLDNN = setBool mklDnnSupport;
  USE_MKLDNN_CBLAS = setBool mklDnnSupport;

  # Avoid using pybind11 from git submodule
  # Also avoids pytorch exporting the headers of pybind11
  USE_SYSTEM_PYBIND11 = true;

  # NB technical debt: building without NNPACK as workaround for missing `six`
  USE_NNPACK = 0;

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
    ${python.pythonOnBuildForHost.interpreter} setup.py build --cmake-only
    ${cmake}/bin/cmake build
  '';

  preFixup = ''
    function join_by { local IFS="$1"; shift; echo "$*"; }
    function strip2 {
      IFS=':'
      read -ra RP <<< $(patchelf --print-rpath $1)
      IFS=' '
      RP_NEW=$(join_by : ''${RP[@]:2})
      patchelf --set-rpath \$ORIGIN:''${RP_NEW} "$1"
    }
    for f in $(find ''${out} -name 'libcaffe2*.so')
    do
      strip2 $f
    done
  '';

  # Override the (weirdly) wrong version set by default. See
  # https://github.com/NixOS/nixpkgs/pull/52437#issuecomment-449718038
  # https://github.com/pytorch/pytorch/blob/v1.0.0/setup.py#L267
  PYTORCH_BUILD_VERSION = version;
  PYTORCH_BUILD_NUMBER = 0;

  # In-tree builds of NCCL are not supported.
  # Use NCCL when cudaSupport is enabled and nccl is available.
  USE_NCCL = setBool useSystemNccl;
  USE_SYSTEM_NCCL = USE_NCCL;
  USE_STATIC_NCCL = USE_NCCL;

  # Set the correct Python library path, broken since
  # https://github.com/pytorch/pytorch/commit/3d617333e
  PYTHON_LIB_REL_PATH = "${placeholder "out"}/${python.sitePackages}";

  # Suppress a weird warning in mkl-dnn, part of ideep in pytorch
  # (upstream seems to have fixed this in the wrong place?)
  # https://github.com/intel/mkl-dnn/commit/8134d346cdb7fe1695a2aa55771071d455fae0bc
  # https://github.com/pytorch/pytorch/issues/22346
  #
  # Also of interest: pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
  # https://github.com/pytorch/pytorch/blob/v1.11.0/setup.py#L17
  env.NIX_CFLAGS_COMPILE = toString (
    (
      lib.optionals (blas.implementation == "mkl") [ "-Wno-error=array-bounds" ]
      # Suppress gcc regression: avx512 math function raises uninitialized variable warning
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105593
      # See also: Fails to compile with GCC 12.1.0 https://github.com/pytorch/pytorch/issues/77939
      ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12.0.0") [
        "-Wno-error=maybe-uninitialized"
        "-Wno-error=uninitialized"
      ]
      # Since pytorch 2.0:
      # gcc-12.2.0/include/c++/12.2.0/bits/new_allocator.h:158:33: error: ‘void operator delete(void*, std::size_t)’
      # ... called on pointer ‘<unknown>’ with nonzero offset [1, 9223372036854775800] [-Werror=free-nonheap-object]
      ++ lib.optionals (stdenv.cc.isGNU && lib.versions.major stdenv.cc.version == "12") [
        "-Wno-error=free-nonheap-object"
      ]
      # .../source/torch/csrc/autograd/generated/python_functions_0.cpp:85:3:
      # error: cast from ... to ... converts to incompatible function type [-Werror,-Wcast-function-type-strict]
      ++ lib.optionals (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16") [
        "-Wno-error=cast-function-type-strict"
        # Suppresses the most spammy warnings.
        # This is mainly to fix https://github.com/NixOS/nixpkgs/issues/266895.
      ]
      ++ lib.optionals rocmSupport [
        "-Wno-#warnings"
        "-Wno-cpp"
        "-Wno-unknown-warning-option"
        "-Wno-ignored-attributes"
        "-Wno-deprecated-declarations"
        "-Wno-defaulted-function-deleted"
        "-Wno-pass-failed"
      ]
      ++ [
        "-Wno-unused-command-line-argument"
        "-Wno-uninitialized"
        "-Wno-array-bounds"
        "-Wno-free-nonheap-object"
        "-Wno-unused-result"
      ]
      ++ lib.optionals stdenv.cc.isGNU [
        "-Wno-maybe-uninitialized"
        "-Wno-stringop-overflow"
      ]
    )
  );

  nativeBuildInputs =
    [
      cmake
      which
      ninja
      pybind11
      removeReferencesTo
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        autoAddDriverRunpath
        cuda_nvcc
      ]
    )
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  buildInputs =
    [
      blas
      blas.provider
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cccl # <thrust/*>
        cuda_cudart # cuda_runtime.h and libraries
        cuda_cupti # For kineto
        cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildinputs, it's needed here too
        cuda_nvml_dev # <nvml.h>
        cuda_nvrtc
        cuda_nvtx # -llibNVToolsExt
        libcublas
        libcufft
        libcurand
        libcusolver
        libcusparse
      ]
      ++ lists.optionals (cudaPackages ? cudnn) [ cudnn ]
      ++ lists.optionals useSystemNccl [
        # Some platforms do not support NCCL (i.e., Jetson)
        nccl # Provides nccl.h AND a static copy of NCCL!
      ]
      ++ lists.optionals (strings.versionOlder cudaVersion "11.8") [
        cuda_nvprof # <cuda_profiler_api.h>
      ]
      ++ lists.optionals (strings.versionAtLeast cudaVersion "11.8") [
        cuda_profiler_api # <cuda_profiler_api.h>
      ]
    )
    ++ lib.optionals rocmSupport [ rocmPackages.llvm.openmp ]
    ++ lib.optionals (cudaSupport || rocmSupport) [ effectiveMagma ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ numactl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Accelerate
      CoreServices
      libobjc
    ]
    ++ lib.optionals tritonSupport [ triton ]
    ++ lib.optionals MPISupport [ mpi ]
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  dependencies = [
    astunparse
    cffi
    click
    numpy
    pyyaml

    # From install_requires:
    fsspec
    filelock
    typing-extensions
    sympy
    networkx
    jinja2

    # the following are required for tensorboard support
    pillow
    six
    future
    tensorboard
    protobuf

    # torch/csrc requires `pybind11` at runtime
    pybind11
  ] ++ lib.optionals tritonSupport [ triton ];

  propagatedCxxBuildInputs =
    [ ] ++ lib.optionals MPISupport [ mpi ] ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  # Tests take a long time and may be flaky, so just sanity-check imports
  doCheck = false;

  pythonImportsCheck = [ "torch" ];

  nativeCheckInputs = [
    hypothesis
    ninja
    psutil
  ];

  checkPhase =
    with lib.versions;
    with lib.strings;
    concatStringsSep " " [
      "runHook preCheck"
      "${python.interpreter} test/run_test.py"
      "--exclude"
      (concatStringsSep " " [
        "utils" # utils requires git, which is not allowed in the check phase

        # "dataloader" # psutils correctly finds and triggers multiprocessing, but is too sandboxed to run -- resulting in numerous errors
        # ^^^^^^^^^^^^ NOTE: while test_dataloader does return errors, these are acceptable errors and do not interfere with the build

        # tensorboard has acceptable failures for pytorch 1.3.x due to dependencies on tensorboard-plugins
        (optionalString (majorMinor version == "1.3") "tensorboard")
      ])
      "runHook postCheck"
    ];

  pythonRemoveDeps = [
    # In our dist-info the name is just "triton"
    "pytorch-triton-rocm"
  ];

  postInstall =
    ''
      find "$out/${python.sitePackages}/torch/include" "$out/${python.sitePackages}/torch/lib" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +

      mkdir $dev
      cp -r $out/${python.sitePackages}/torch/include $dev/include
      cp -r $out/${python.sitePackages}/torch/share $dev/share

      # Fix up library paths for split outputs
      substituteInPlace \
        $dev/share/cmake/Torch/TorchConfig.cmake \
        --replace \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

      substituteInPlace \
        $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
        --replace \''${_IMPORT_PREFIX}/lib "$lib/lib"

      mkdir $lib
      mv $out/${python.sitePackages}/torch/lib $lib/lib
      ln -s $lib/lib $out/${python.sitePackages}/torch/lib
    ''
    + lib.optionalString rocmSupport ''
      substituteInPlace $dev/share/cmake/Tensorpipe/TensorpipeTargets-release.cmake \
        --replace "\''${_IMPORT_PREFIX}/lib64" "$lib/lib"

      substituteInPlace $dev/share/cmake/ATen/ATenConfig.cmake \
        --replace "/build/source/torch/include" "$dev/include"
    '';

  postFixup =
    ''
      mkdir -p "$cxxdev/nix-support"
      printWords "''${propagatedCxxBuildInputs[@]}" >> "$cxxdev/nix-support/propagated-build-inputs"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      for f in $(ls $lib/lib/*.dylib); do
          install_name_tool -id $lib/lib/$(basename $f) $f || true
      done

      install_name_tool -change @rpath/libshm.dylib $lib/lib/libshm.dylib $lib/lib/libtorch_python.dylib
      install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libtorch_python.dylib
      install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libtorch_python.dylib

      install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libtorch.dylib

      install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libshm.dylib
      install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libshm.dylib
    '';

  # See https://github.com/NixOS/nixpkgs/issues/296179
  #
  # This is a quick hack to add `libnvrtc` to the runpath so that torch can find
  # it when it is needed at runtime.
  extraRunpaths = lib.optionals cudaSupport [ "${lib.getLib cudaPackages.cuda_nvrtc}/lib" ];
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "postPatchelfPhase" ];
  postPatchelfPhase = ''
    while IFS= read -r -d $'\0' elf ; do
      for extra in $extraRunpaths ; do
        echo patchelf "$elf" --add-rpath "$extra" >&2
        patchelf "$elf" --add-rpath "$extra"
      done
    done < <(
      find "''${!outputLib}" "$out" -type f -iname '*.so' -print0
    )
  '';

  # Builds in 2+h with 2 cores, and ~15m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    inherit
      cudaSupport
      cudaPackages
      rocmSupport
      rocmPackages
      ;
    cudaCapabilities = if cudaSupport then supportedCudaCapabilities else [ ];
    # At least for 1.10.2 `torch.fft` is unavailable unless BLAS provider is MKL. This attribute allows for easy detection of its availability.
    blasProvider = blas.provider;
    # To help debug when a package is broken due to CUDA support
    inherit brokenConditions;
    tests = callPackage ./tests.nix { };
  };

  meta = {
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # keep PyTorch in the description so the package can be found under that name on search.nixos.org
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      teh
      thoughtpolice
      tscholak
    ]; # tscholak esp. for darwin-related builds
    platforms = with lib.platforms; linux ++ lib.optionals (!cudaSupport && !rocmSupport) darwin;
    broken = builtins.any trivial.id (builtins.attrValues brokenConditions);
  };
}
