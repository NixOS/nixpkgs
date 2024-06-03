{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  which,
  ninja,
  packaging,
  setuptools,
  torch,
  outlines,
  wheel,
  psutil,
  ray,
  pandas,
  pyarrow,
  sentencepiece,
  numpy,
  transformers,
  xformers,
  fastapi,
  uvicorn,
  pydantic,
  aioprometheus,
  pynvml,
  cupy,
  writeShellScript,

  config,

  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },
  gpuTargets ? [ ],
}:

buildPythonPackage rec {
  pname = "vllm";
  version = "0.3.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LU5pCPVv+Ws9dL8oWL1sJGzwQKI1IFk2A1I6TP9gXL4=";
  };

  # Otherwise it tries to enumerate host supported ROCM gfx archs, and that is not possible due to sandboxing.
  PYTORCH_ROCM_ARCH = lib.optionalString rocmSupport (
    lib.strings.concatStringsSep ";" rocmPackages.clr.gpuTargets
  );

  # xformers 0.0.23.post1 github release specifies its version as 0.0.24
  #
  # cupy-cuda12x is the same wheel as cupy, but built with cuda dependencies, we already have it set up
  # like that in nixpkgs. Version upgrade is due to upstream shenanigans
  # https://github.com/vllm-project/vllm/pull/2845/commits/34a0ad7f9bb7880c0daa2992d700df3e01e91363
  #
  # hipcc --version works badly on NixOS due to unresolved paths.
  postPatch =
    ''
      substituteInPlace requirements.txt \
        --replace "xformers == 0.0.23.post1" "xformers == 0.0.24"
      substituteInPlace requirements.txt \
        --replace "cupy-cuda12x == 12.1.0" "cupy == 12.3.0"
      substituteInPlace requirements-build.txt \
        --replace "torch==2.1.2" "torch == 2.2.1"
      substituteInPlace pyproject.toml \
        --replace "torch == 2.1.2" "torch == 2.2.1"
      substituteInPlace requirements.txt \
        --replace "torch == 2.1.2" "torch == 2.2.1"
    ''
    + lib.optionalString rocmSupport ''
      substituteInPlace setup.py \
        --replace "'hipcc', '--version'" "'${writeShellScript "hipcc-version-stub" "echo HIP version: 0.0"}'"
    '';

  preBuild =
    lib.optionalString cudaSupport ''
      export CUDA_HOME=${cudaPackages.cuda_nvcc}
    ''
    + lib.optionalString rocmSupport ''
      export ROCM_HOME=${rocmPackages.clr}
      export PATH=$PATH:${rocmPackages.hipcc}
    '';

  nativeBuildInputs = [
    ninja
    packaging
    setuptools
    torch
    wheel
    which
  ] ++ lib.optionals rocmSupport [ rocmPackages.hipcc ];

  buildInputs =
    (lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h, -lcudart
        cuda_cccl.dev # <thrust/*>
        libcusparse.dev # cusparse.h
        libcublas.dev # cublas_v2.h
        libcusolver # cusolverDn.h
      ]
    ))
    ++ (lib.optionals rocmSupport (
      with rocmPackages;
      [
        clr
        rocthrust
        rocprim
        hipsparse
        hipblas
      ]
    ));

  propagatedBuildInputs =
    [
      psutil
      ray
      pandas
      pyarrow
      sentencepiece
      numpy
      torch
      transformers
      outlines
      xformers
      fastapi
      uvicorn
      pydantic
      aioprometheus
    ]
    ++ uvicorn.optional-dependencies.standard
    ++ aioprometheus.optional-dependencies.starlette
    ++ lib.optionals cudaSupport [
      pynvml
      cupy
    ];

  pythonImportsCheck = [ "vllm" ];

  meta = with lib; {
    description = "A high-throughput and memory-efficient inference and serving engine for LLMs";
    changelog = "https://github.com/vllm-project/vllm/releases/tag/v${version}";
    homepage = "https://github.com/vllm-project/vllm";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      lach
    ];
    broken = !cudaSupport && !rocmSupport;
  };
}
