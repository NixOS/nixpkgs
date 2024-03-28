{ stdenv, lib, fetchFromGitHub, fetchFromGitLab, fetchpatch,
  buildPythonPackage, python, runCommand,
  config, cudaSupport ? config.cudaSupport, cudaPackages,
  effectiveMagma ?
  if cudaSupport then magma-cuda-static
  else if rocmSupport then magma-hip
  else magma,
  magma,
  magma-hip,
  magma-cuda-static,
  # Use the system NCCL as long as we're targeting CUDA on a supported platform.
  useSystemNccl ? (cudaSupport && !cudaPackages.nccl.meta.unsupported || rocmSupport),
  MPISupport ? false, mpi,
  buildDocs ? false,

  # Native build inputs
  cmake, linkFarm, symlinkJoin, which, pybind11, removeReferencesTo,
  pythonRelaxDepsHook,

  # Build inputs
  numactl,
  Accelerate, CoreServices, libobjc,

  # Propagated build inputs
  astunparse,
  fsspec,
  filelock,
  jinja2,
  networkx,
  sympy,
  numpy, pyyaml, cffi, click, typing-extensions,
  # ROCm build and `torch.compile` requires `openai-triton`
  tritonSupport ? (!stdenv.isDarwin), openai-triton,

  # Unit tests
  hypothesis, psutil,

  # Disable MKLDNN on aarch64-darwin, it negatively impacts performance,
  # this is also what official pytorch build does
  mklDnnSupport ? !(stdenv.isDarwin && stdenv.isAarch64),

  # virtual pkg that consistently instantiates blas across nixpkgs
  # See https://github.com/NixOS/nixpkgs/pull/83888
  blas,

  # ninja (https://ninja-build.org) must be available to run C++ extensions tests,
  ninja,

  # dependencies for torch.utils.tensorboard
  pillow, six, future, tensorboard, protobuf,

  pythonOlder,

  # ROCm dependencies
  rocmSupport ? config.rocmSupport,
  rocmPackages,
  gpuTargets ? [ ]
}:

let
  inherit (lib) attrsets lists strings trivial;
  inherit (cudaPackages) cudaFlags cudnn nccl;

  setBool = v: if v then "1" else "0";

  # https://github.com/pytorch/pytorch/blob/v2.0.1/torch/utils/cpp_extension.py#L1744
  supportedTorchCudaCapabilities =
    let
      real = ["3.5" "3.7" "5.0" "5.2" "5.3" "6.0" "6.1" "6.2" "7.0" "7.2" "7.5" "8.0" "8.6" "8.7" "8.9" "9.0"];
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
  gpuArchWarner = supported: unsupported:
    trivial.throwIf (supported == [ ])
      (
        "No supported GPU targets specified. Requested GPU targets: "
        + strings.concatStringsSep ", " unsupported
      )
      supported;

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
      rocm-core clr rccl miopen miopengemm rocrand rocblas
      rocsparse hipsparse rocthrust rocprim hipcub roctracer
      rocfft rocsolver hipfft hipsolver hipblas
      rocminfo rocm-thunk rocm-comgr rocm-device-libs
      rocm-runtime clr.icd hipify
    ];

    # Fix `setuptools` not being found
    postBuild = ''
      rm -rf $out/nix-support
    '';
  };

  brokenConditions = attrsets.filterAttrs (_: cond: cond) {
    "CUDA and ROCm are mutually exclusive" = cudaSupport && rocmSupport;
    "CUDA is not targeting Linux" = cudaSupport && !stdenv.isLinux;
    "Unsupported CUDA version" = cudaSupport && !(builtins.elem cudaPackages.cudaMajorVersion [ "11" "12" ]);
    "MPI cudatoolkit does not match cudaPackages.cudatoolkit" = MPISupport && cudaSupport && (mpi.cudatoolkit != cudaPackages.cudatoolkit);
    "Magma cudaPackages does not match cudaPackages" = cudaSupport && (effectiveMagma.cudaPackages != cudaPackages);
  };
in buildPythonPackage rec {
  pname = "torch";
  # Don't forget to update torch-bin to the same version.
  version = "2.2.1";
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
  src = assert version == "2.2.1"; (rec {
    src_ARM_NEON_2_x86_SSE = fetchFromGitHub {
      owner = "intel";
      repo = "ARM_NEON_2_x86_SSE";
      rev = "97a126f08ce318023be604d03f88bf0820a9464a";
      hash = "sha256-yMRVymKVro2TtBGiGt3FJkcdoJcIIAzDjx2hMlZZeDA=";
    };
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
    src_QNNPACK = fetchFromGitHub {
      owner = "pytorch";
      repo = "QNNPACK";
      rev = "7d2a4e9931a82adc3814275b6219a03e24e36b4c";
      hash = "sha256-hfX7Stz1km3McpTWtruxf3FyKPGCdMhd1lmlr2LM/7U=";
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
      rev = "51a987591a6fc9f0fc0707077f53d763ac132cbf";
      hash = "sha256-NZeSKz6xpvH84V4sxArXlyUoEfoekdACzaAh3AXy6+c=";
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
    src_benchmark_onnx_onnx-tensorrt = fetchFromGitHub {
      owner = "google";
      repo = "benchmark";
      rev = "e776aa0275e293707b6a0901e0e8d8a8a3679508";
      hash = "sha256-bYaoGPiuhtGoNpRufjI9W8N+a8UE1jbRmq4gNb8yLlA=";
    };
    src_benchmark_protobuf = fetchFromGitHub {
      owner = "google";
      repo = "benchmark";
      rev = "5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8";
      hash = "sha256-iFRgjLkftuszAqBnmS9GXU8BwYnabmwMAQyw19sfjb4=";
    };
    src_clang-cindex-python3 = fetchFromGitHub {
      owner = "wjakob";
      repo = "clang-cindex-python3";
      rev = "6a00cbc4a9b8e68b71caf7f774b3f9c753ae84d5";
      hash = "sha256-IDUIuAvgCzWaHoTJUZrH15bqoVcP8bZk+Gs1Ae6/CpY=";
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
      rev = "6481e8bef08f606ddd627e4d3be89f64d62e1b8a";
      hash = "sha256-jOpCcrPK+9+gWGAW4sbw9bKojcWs+TqEfqawsBg/rsg=";
    };
    src_cpuinfo_fbgemm = fetchFromGitHub {
      owner = "pytorch";
      repo = "cpuinfo";
      rev = "ed8b86a253800bafdb7b25c5c399f91bff9cb1f3";
      hash = "sha256-YRqBU83AjxbSE5zquhi4iIiJna/qFWA0jo2GBifqzi8=";
    };
    src_cub = fetchFromGitHub {
      owner = "NVlabs";
      repo = "cub";
      rev = "d106ddb991a56c3df1b6d51b2409e36ba8181ce4";
      hash = "sha256-vnfycrL9ItpmVvWmYFeydmnjnw/Ywq8JlVQ0aycBQ8Y=";
    };
    src_cudnn-frontend = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "cudnn-frontend";
      rev = "12f35fa2be5994c1106367cac2fba21457b064f4";
      hash = "sha256-2bMBupA/LLofc+d42yzoGHEIQVqfG4Bss/jwd0ZXI9o=";
    };
    src_cutlass = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "cutlass";
      rev = "44c704eae85da352d277d6f092f41412772f70e4";
      hash = "sha256-lw+5TrOBIfzfVlDhTTu5Sdp/Ss+8J65G/bTZesed3WM=";
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
      rev = "88fc6e741bc03e09fcdc3cd365fa3aafddb7ec24";
      hash = "sha256-fdKug5Ueu6LOxDRKZsg4lRt4uO3HmrSBdt9Gl7hGhpU=";
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
      rev = "f5e54359df4c26b6230fc61d38aa294581393084";
      hash = "sha256-H9+1lEaHM12nzXSmo9m8S6527t+97e6necayyjCPm1A=";
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
      rev = "cf1e1abc95d0b961222ee82b6935f76250fbcf16";
      hash = "sha256-6GoT+hsaXRtq3rgH8JtkguH4Ke9PPb0YsXIn3nEQSts=";
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
      rev = "e212bbbf81e2a29a82651ae55dc1effa8830f31a";
      hash = "sha256-Kxs0DHfxD5v580DpXR9rNTpN43Lg5hKcXSP6jNFI2Xg=";
    };
    src_ios-cmake = fetchFromGitHub {
      owner = "Yangqing";
      repo = "ios-cmake";
      rev = "8abaed637d56f1337d6e1d2c4026e25c1eade724";
      hash = "sha256-htA8g1pQidNLgw6a5ol+QnX2XRGAdGGWSH0Vykw8a9U=";
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
    src_kineto = fetchFromGitHub {
      owner = "pytorch";
      repo = "kineto";
      rev = "a30ca3f9509c2cfd28561abbca51328f0bdf9014";
      hash = "sha256-Ce7zT9a8JFfvjIZrz1TlFPmKoAV3YFXtAP7Av3dcG6s=";
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
      rev = "2dc95a2ad0841e29db8b22fbccaf3e5da7992b01";
      hash = "sha256-ARE48AzSWf+wMb3qJV8SQRlIiEirI4s6NGFstSEUv3w=";
    };
    src_nccl = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "nccl";
      rev = "8c6c5951854a57ba90c4424fa040497f6defac46";
      hash = "sha256-59FlOKM5EB5Vkm4dZBRCkn+IgIcdQehE+FyZAdTCT/A=";
    };
    src_onnx = fetchFromGitHub {
      owner = "onnx";
      repo = "onnx";
      rev = "ccde5da81388ffa770ca98b64e07f803ad089414";
      hash = "sha256-VfKj32CVgvElm5c9cjERO45QuKQMRtbuMzRTMub8JYs=";
    };
    src_onnx-tensorrt = fetchFromGitHub {
      owner = "onnx";
      repo = "onnx-tensorrt";
      rev = "c153211418a7c57ce071d9ce2a41f8d1c85a878f";
      hash = "sha256-kHIHkC65Kc1bCZzzygYtEyNZ3YT5fLkrrmp/tdFjkVY=";
    };
    src_onnx_onnx-tensorrt = fetchFromGitHub {
      owner = "onnx";
      repo = "onnx";
      rev = "765f5ee823a67a866f4bd28a9860e81f3c811ce8";
      hash = "sha256-EZP5F6zkWsJ6YhmZ8x6nEAzahp/ERulGOX49hTd50V4=";
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
      rev = "ea778e37710c07723435b1be58235996d1d43a5a";
      hash = "sha256-g0my22ILjZhmRpftEWvju5i4nDYTFv491/rpdK4G42k=";
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
      rev = "8a099e44b3d5f85b20f05828d919d2332a8de841";
      hash = "sha256-sO/Fa+QrAKyq2EYyYMcjPrYI+bdJIrDoj6L3JHoDo3E=";
    };
    src_pybind11_onnx = fetchFromGitHub {
      owner = "pybind";
      repo = "pybind11";
      rev = "5b0a6fc2017fcc176545afe3e09c9f9885283242";
      hash = "sha256-n7nLEG2+sSR9wnxM+C8FWc2B+Mx74Pan1+IQf+h2bGU=";
    };
    src_pybind11_onnx_onnx-tensorrt = fetchFromGitHub {
      owner = "pybind";
      repo = "pybind11";
      rev = "a1041190c8b8ff0cd9e2f0752248ad5e3789ea0c";
      hash = "sha256-ihrjvaPuaeegf9y//O5VvKQxrwWP8BsX74ud1cLcOkA=";
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
      rev = "v2.2.1";
      hash = "sha256-iORAT51feZqTpYTVOgPi8snoEmRs8Firbp2WxfkFtQ4=";
    };
    src_sleef = fetchFromGitHub {
      owner = "shibatch";
      repo = "sleef";
      rev = "e0a003ee838b75d11763aa9c3ef17bf71a725bff";
      hash = "sha256-0atbkbLqyMVdZDZiSvGNp7vgZ6/dAQz9BL4Wu2kURlY=";
    };
    src_tbb = fetchFromGitHub {
      owner = "01org";
      repo = "tbb";
      rev = "a51a90bc609bb73db8ea13841b5cf7aa4344d4a9";
      hash = "sha256-FMW2Ey9t5MThz14cw02aYmQDjrDVPa2bQ70Ccz6uCNA=";
    };
    src_tensorpipe = fetchFromGitHub {
      owner = "pytorch";
      repo = "tensorpipe";
      rev = "52791a2fd214b2a9dc5759d36725909c1daa7f2e";
      hash = "sha256-i+CtjNFPDUzFCPxP0//jMLJDrQoorg0On9NfoVaMUxI=";
    };
    src_zstd = fetchFromGitHub {
      owner = "facebook";
      repo = "zstd";
      rev = "aec56a52fbab207fc639a1937d1e708a282edca8";
      hash = "sha256-QkcK1ubrcE9tWUm4viU/nOWWEwaqkF7BhNqBkw93zpE=";
    };
    src_ARM_NEON_2_x86_SSE_recursive = src_ARM_NEON_2_x86_SSE;
    src_DCGM_recursive = src_DCGM;
    src_FP16_recursive = src_FP16;
    src_FXdiv_recursive = src_FXdiv;
    src_NNPACK_recursive = src_NNPACK;
    src_PeachPy_recursive = src_PeachPy;
    src_QNNPACK_recursive = src_QNNPACK;
    src_VulkanMemoryAllocator_recursive = src_VulkanMemoryAllocator;
    src_XNNPACK_recursive = src_XNNPACK;
    src_asmjit_recursive = src_asmjit;
    src_benchmark_recursive = src_benchmark;
    src_benchmark_onnx_recursive = src_benchmark_onnx;
    src_benchmark_onnx_onnx-tensorrt_recursive = src_benchmark_onnx_onnx-tensorrt;
    src_benchmark_protobuf_recursive = src_benchmark_protobuf;
    src_clang-cindex-python3_recursive = src_clang-cindex-python3;
    src_cpr_recursive = src_cpr;
    src_cpuinfo_recursive = src_cpuinfo;
    src_cpuinfo_fbgemm_recursive = src_cpuinfo_fbgemm;
    src_cub_recursive = src_cub;
    src_cudnn-frontend_recursive = src_cudnn-frontend;
    src_cutlass_recursive = src_cutlass;
    src_cutlass_fbgemm_recursive = src_cutlass_fbgemm;
    src_dynolog_recursive = runCommand "dynolog" {} ''
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
    src_fbgemm_recursive = runCommand "fbgemm" {} ''
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
    src_gflags_recursive = runCommand "gflags" {} ''
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
    src_googletest_protobuf_recursive = src_googletest_protobuf;
    src_googletest_tensorpipe_recursive = src_googletest_tensorpipe;
    src_hipify_torch_recursive = src_hipify_torch;
    src_ideep_recursive = runCommand "ideep" {} ''
      cp -r ${src_ideep} $out
      chmod u+w $out/mkl-dnn
      cp -r ${src_mkl-dnn_recursive}/* $out/mkl-dnn
    '';
    src_ios-cmake_recursive = src_ios-cmake;
    src_ittapi_recursive = src_ittapi;
    src_json_recursive = src_json;
    src_json_dynolog_recursive = src_json_dynolog;
    src_kineto_recursive = runCommand "kineto" {} ''
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
    src_onnx_recursive = runCommand "onnx" {} ''
      cp -r ${src_onnx} $out
      chmod u+w $out/third_party/benchmark
      cp -r ${src_benchmark_onnx_recursive}/* $out/third_party/benchmark
      chmod u+w $out/third_party/pybind11
      cp -r ${src_pybind11_onnx_recursive}/* $out/third_party/pybind11
    '';
    src_onnx-tensorrt_recursive = runCommand "onnx-tensorrt" {} ''
      cp -r ${src_onnx-tensorrt} $out
      chmod u+w $out/third_party/onnx
      cp -r ${src_onnx_onnx-tensorrt_recursive}/* $out/third_party/onnx
    '';
    src_onnx_onnx-tensorrt_recursive = runCommand "onnx_onnx-tensorrt" {} ''
      cp -r ${src_onnx_onnx-tensorrt} $out
      chmod u+w $out/third_party/benchmark
      cp -r ${src_benchmark_onnx_onnx-tensorrt_recursive}/* $out/third_party/benchmark
      chmod u+w $out/third_party/pybind11
      cp -r ${src_pybind11_onnx_onnx-tensorrt_recursive}/* $out/third_party/pybind11
    '';
    src_pfs_recursive = src_pfs;
    src_pocketfft_recursive = src_pocketfft;
    src_protobuf_recursive = runCommand "protobuf" {} ''
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
    src_pybind11_onnx_onnx-tensorrt_recursive = runCommand "pybind11_onnx_onnx-tensorrt" {} ''
      cp -r ${src_pybind11_onnx_onnx-tensorrt} $out
      chmod u+w $out/tools/clang
      cp -r ${src_clang-cindex-python3_recursive}/* $out/tools/clang
    '';
    src_pybind11_tensorpipe_recursive = runCommand "pybind11_tensorpipe" {} ''
      cp -r ${src_pybind11_tensorpipe} $out
      chmod u+w $out/tools/clang
      cp -r ${src_clang-cindex-python3_recursive}/* $out/tools/clang
    '';
    src_pytorch_recursive = runCommand "pytorch" {} ''
      cp -r ${src_pytorch} $out
      chmod u+w $out/android/libs/fbjni
      cp -r ${src_fbjni_recursive}/* $out/android/libs/fbjni
      chmod u+w $out/third_party/FP16
      cp -r ${src_FP16_recursive}/* $out/third_party/FP16
      chmod u+w $out/third_party/FXdiv
      cp -r ${src_FXdiv_recursive}/* $out/third_party/FXdiv
      chmod u+w $out/third_party/NNPACK
      cp -r ${src_NNPACK_recursive}/* $out/third_party/NNPACK
      chmod u+w $out/third_party/QNNPACK
      cp -r ${src_QNNPACK_recursive}/* $out/third_party/QNNPACK
      chmod u+w $out/third_party/VulkanMemoryAllocator
      cp -r ${src_VulkanMemoryAllocator_recursive}/* $out/third_party/VulkanMemoryAllocator
      chmod u+w $out/third_party/XNNPACK
      cp -r ${src_XNNPACK_recursive}/* $out/third_party/XNNPACK
      chmod u+w $out/third_party/benchmark
      cp -r ${src_benchmark_recursive}/* $out/third_party/benchmark
      chmod u+w $out/third_party/cpuinfo
      cp -r ${src_cpuinfo_recursive}/* $out/third_party/cpuinfo
      chmod u+w $out/third_party/cub
      cp -r ${src_cub_recursive}/* $out/third_party/cub
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
      chmod u+w $out/third_party/ios-cmake
      cp -r ${src_ios-cmake_recursive}/* $out/third_party/ios-cmake
      chmod u+w $out/third_party/ittapi
      cp -r ${src_ittapi_recursive}/* $out/third_party/ittapi
      chmod u+w $out/third_party/kineto
      cp -r ${src_kineto_recursive}/* $out/third_party/kineto
      chmod u+w $out/third_party/mimalloc
      cp -r ${src_mimalloc_recursive}/* $out/third_party/mimalloc
      chmod u+w $out/third_party/nccl/nccl
      cp -r ${src_nccl_recursive}/* $out/third_party/nccl/nccl
      chmod u+w $out/third_party/neon2sse
      cp -r ${src_ARM_NEON_2_x86_SSE_recursive}/* $out/third_party/neon2sse
      chmod u+w $out/third_party/nlohmann
      cp -r ${src_json_recursive}/* $out/third_party/nlohmann
      chmod u+w $out/third_party/onnx
      cp -r ${src_onnx_recursive}/* $out/third_party/onnx
      chmod u+w $out/third_party/onnx-tensorrt
      cp -r ${src_onnx-tensorrt_recursive}/* $out/third_party/onnx-tensorrt
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
      chmod u+w $out/third_party/tbb
      cp -r ${src_tbb_recursive}/* $out/third_party/tbb
      chmod u+w $out/third_party/tensorpipe
      cp -r ${src_tensorpipe_recursive}/* $out/third_party/tensorpipe
      chmod u+w $out/third_party/zstd
      cp -r ${src_zstd_recursive}/* $out/third_party/zstd
    '';
    src_sleef_recursive = src_sleef;
    src_tbb_recursive = src_tbb;
    src_tensorpipe_recursive = runCommand "tensorpipe" {} ''
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
    src_zstd_recursive = src_zstd;
  }).src_pytorch_recursive;

  patches = lib.optionals cudaSupport [
    ./fix-cmake-cuda-toolkit.patch
  ]
  ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # pthreadpool added support for Grand Central Dispatch in April
    # 2020. However, this relies on functionality (DISPATCH_APPLY_AUTO)
    # that is available starting with macOS 10.13. However, our current
    # base is 10.12. Until we upgrade, we can fall back on the older
    # pthread support.
    ./pthreadpool-disable-gcd.diff
  ] ++ lib.optionals stdenv.isLinux [
    # Propagate CUPTI to Kineto by overriding the search path with environment variables.
    # https://github.com/pytorch/pytorch/pull/108847
    ./pytorch-pr-108847.patch
  ];

  postPatch = lib.optionalString rocmSupport ''
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
  # Remove PyTorch's FindCUDAToolkit.cmake and to use CMake's default.
  # We do not remove the entirety of cmake/Modules_CUDA_fix because we need FindCUDNN.cmake.
  + lib.optionalString cudaSupport ''
    rm cmake/Modules/FindCUDAToolkit.cmake
    rm -rf cmake/Modules_CUDA_fix/{upstream,FindCUDA.cmake}
  ''
  # error: no member named 'aligned_alloc' in the global namespace; did you mean simply 'aligned_alloc'
  # This lib overrided aligned_alloc hence the error message. Tltr: his function is linkable but not in header.
  + lib.optionalString (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0") ''
    substituteInPlace third_party/pocketfft/pocketfft_hdronly.h --replace '#if __cplusplus >= 201703L
    inline void *aligned_alloc(size_t align, size_t size)' '#if __cplusplus >= 201703L && 0
    inline void *aligned_alloc(size_t align, size_t size)'
  '';

  # NOTE(@connorbaker): Though we do not disable Gloo or MPI when building with CUDA support, caution should be taken
  # when using the different backends. Gloo's GPU support isn't great, and MPI and CUDA can't be used at the same time
  # without extreme care to ensure they don't lock each other out of shared resources.
  # For more, see https://github.com/open-mpi/ompi/issues/7733#issuecomment-629806195.
  preConfigure = lib.optionalString cudaSupport ''
    export TORCH_CUDA_ARCH_LIST="${gpuTargetString}"
    export CUPTI_INCLUDE_DIR=${cudaPackages.cuda_cupti.dev}/include
    export CUPTI_LIBRARY_DIR=${cudaPackages.cuda_cupti.lib}/lib
  '' + lib.optionalString (cudaSupport && cudaPackages ? cudnn) ''
    export CUDNN_INCLUDE_DIR=${cudnn.dev}/include
    export CUDNN_LIB_DIR=${cudnn.lib}/lib
  '' + lib.optionalString rocmSupport ''
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

  # Suppress a weird warning in mkl-dnn, part of ideep in pytorch
  # (upstream seems to have fixed this in the wrong place?)
  # https://github.com/intel/mkl-dnn/commit/8134d346cdb7fe1695a2aa55771071d455fae0bc
  # https://github.com/pytorch/pytorch/issues/22346
  #
  # Also of interest: pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
  # https://github.com/pytorch/pytorch/blob/v1.11.0/setup.py#L17
  env.NIX_CFLAGS_COMPILE = toString ((lib.optionals (blas.implementation == "mkl") [ "-Wno-error=array-bounds" ]
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
  ++ lib.optionals (stdenv.cc.isGNU && lib.versions.major stdenv.cc.version == "12" ) [
    "-Wno-error=free-nonheap-object"
  ]
  # .../source/torch/csrc/autograd/generated/python_functions_0.cpp:85:3:
  # error: cast from ... to ... converts to incompatible function type [-Werror,-Wcast-function-type-strict]
  ++ lib.optionals (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16") [
    "-Wno-error=cast-function-type-strict"
  # Suppresses the most spammy warnings.
  # This is mainly to fix https://github.com/NixOS/nixpkgs/issues/266895.
  ] ++ lib.optionals rocmSupport [
    "-Wno-#warnings"
    "-Wno-cpp"
    "-Wno-unknown-warning-option"
    "-Wno-ignored-attributes"
    "-Wno-deprecated-declarations"
    "-Wno-defaulted-function-deleted"
    "-Wno-pass-failed"
  ] ++ [
    "-Wno-unused-command-line-argument"
    "-Wno-uninitialized"
    "-Wno-array-bounds"
    "-Wno-free-nonheap-object"
    "-Wno-unused-result"
  ] ++ lib.optionals stdenv.cc.isGNU [
    "-Wno-maybe-uninitialized"
    "-Wno-stringop-overflow"
  ]));

  nativeBuildInputs = [
    cmake
    which
    ninja
    pybind11
    pythonRelaxDepsHook
    removeReferencesTo
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    autoAddDriverRunpath
    cuda_nvcc
  ])
  ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  buildInputs = [ blas blas.provider ]
    ++ lib.optionals cudaSupport (with cudaPackages; [
      cuda_cccl.dev # <thrust/*>
      cuda_cudart.dev # cuda_runtime.h and libraries
      cuda_cudart.lib
      cuda_cudart.static
      cuda_cupti.dev # For kineto
      cuda_cupti.lib # For kineto
      cuda_nvcc.dev # crt/host_config.h; even though we include this in nativeBuildinputs, it's needed here too
      cuda_nvml_dev.dev # <nvml.h>
      cuda_nvrtc.dev
      cuda_nvrtc.lib
      cuda_nvtx.dev
      cuda_nvtx.lib # -llibNVToolsExt
      libcublas.dev
      libcublas.lib
      libcufft.dev
      libcufft.lib
      libcurand.dev
      libcurand.lib
      libcusolver.dev
      libcusolver.lib
      libcusparse.dev
      libcusparse.lib
    ] ++ lists.optionals (cudaPackages ? cudnn) [
      cudnn.dev
      cudnn.lib
    ] ++ lists.optionals useSystemNccl [
      # Some platforms do not support NCCL (i.e., Jetson)
      nccl.dev # Provides nccl.h AND a static copy of NCCL!
    ] ++ lists.optionals (strings.versionOlder cudaVersion "11.8") [
      cuda_nvprof.dev # <cuda_profiler_api.h>
    ] ++ lists.optionals (strings.versionAtLeast cudaVersion "11.8") [
      cuda_profiler_api.dev # <cuda_profiler_api.h>
    ])
    ++ lib.optionals rocmSupport [ rocmPackages.llvm.openmp ]
    ++ lib.optionals (cudaSupport || rocmSupport) [ effectiveMagma ]
    ++ lib.optionals stdenv.isLinux [ numactl ]
    ++ lib.optionals stdenv.isDarwin [ Accelerate CoreServices libobjc ]
    ++ lib.optionals tritonSupport [ openai-triton ]
    ++ lib.optionals MPISupport [ mpi ]
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  propagatedBuildInputs = [
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
    pillow six future tensorboard protobuf

    # torch/csrc requires `pybind11` at runtime
    pybind11
  ] ++ lib.optionals tritonSupport [ openai-triton ];

  propagatedCxxBuildInputs = [
  ]
  ++ lib.optionals MPISupport [ mpi ]
  ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  # Tests take a long time and may be flaky, so just sanity-check imports
  doCheck = false;

  pythonImportsCheck = [
    "torch"
  ];

  nativeCheckInputs = [ hypothesis ninja psutil ];

  checkPhase = with lib.versions; with lib.strings; concatStringsSep " " [
    "runHook preCheck"
    "${python.interpreter} test/run_test.py"
    "--exclude"
    (concatStringsSep " " [
      "utils" # utils requires git, which is not allowed in the check phase

      # "dataloader" # psutils correctly finds and triggers multiprocessing, but is too sandboxed to run -- resulting in numerous errors
      # ^^^^^^^^^^^^ NOTE: while test_dataloader does return errors, these are acceptable errors and do not interfere with the build

      # tensorboard has acceptable failures for pytorch 1.3.x due to dependencies on tensorboard-plugins
      (optionalString (majorMinor version == "1.3" ) "tensorboard")
    ])
    "runHook postCheck"
  ];

  pythonRemoveDeps = [
    # In our dist-info the name is just "triton"
    "pytorch-triton-rocm"
  ];

  postInstall = ''
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
  '' + lib.optionalString rocmSupport ''
    substituteInPlace $dev/share/cmake/Tensorpipe/TensorpipeTargets-release.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib64" "$lib/lib"

    substituteInPlace $dev/share/cmake/ATen/ATenConfig.cmake \
      --replace "/build/source/torch/include" "$dev/include"
  '';

  postFixup = ''
    mkdir -p "$cxxdev/nix-support"
    printWords "''${propagatedCxxBuildInputs[@]}" >> "$cxxdev/nix-support/propagated-build-inputs"
  '' + lib.optionalString stdenv.isDarwin ''
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

  # Builds in 2+h with 2 cores, and ~15m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    inherit cudaSupport cudaPackages;
    # At least for 1.10.2 `torch.fft` is unavailable unless BLAS provider is MKL. This attribute allows for easy detection of its availability.
    blasProvider = blas.provider;
    # To help debug when a package is broken due to CUDA support
    inherit brokenConditions;
    cudaCapabilities = if cudaSupport then supportedCudaCapabilities else [ ];
  };

  meta = with lib; {
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # keep PyTorch in the description so the package can be found under that name on search.nixos.org
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh thoughtpolice tscholak ]; # tscholak esp. for darwin-related builds
    platforms = with platforms; linux ++ lib.optionals (!cudaSupport && !rocmSupport) darwin;
    broken = builtins.any trivial.id (builtins.attrValues brokenConditions);
  };
}
