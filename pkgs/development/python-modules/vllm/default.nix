{ lib
, buildPythonPackage
, fetchFromGitHub
, cudaPackages
, which
, ninja
, packaging
, setuptools
, torch
, wheel
, psutil
, ray
, pandas
, pyarrow
, sentencepiece
, numpy
, torch-bin
, transformers
, xformers
, fastapi
, uvicorn
, pydantic
, aioprometheus
, config
, writeShellScript

, cudaSupport ? config.cudaSupport

, rocmSupport ? config.rocmSupport
, rocmPackages
}:
let
  version = "0.3.1";
in
buildPythonPackage {
  pname = "vllm";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "vllm";
    rev = "v${version}";
    hash = "sha256-hfd4ScU0mkZ7z4+w08BUA1K9bPXSiFThfiO+Ll2MTtg=";
  };

  # hipcc --version works badly on NixOS due to unresolved paths.
  postPatch = lib.optionalString rocmSupport ''
    substituteInPlace setup.py \
      --replace "'hipcc', '--version'" "'${writeShellScript "hipcc-version-stub" "echo HIP version: 0.0"}'"
  '';

  preBuild = lib.optionalString cudaSupport ''
    export CUDA_HOME=${cudaPackages.cuda_nvcc}
  '' + lib.optionalString rocmSupport ''
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
  ];

  buildInputs = lib.optionals cudaSupport (with cudaPackages; [
    cuda_cudart.dev # cuda_runtime.h
    cuda_cccl.dev # <thrust/*>
    libcusparse.dev # cusparse.h
    libcublas.dev # cublas_v2.h
    libcusolver # cusolverDn.h
  ]) ++ (lib.optionals rocmSupport (with rocmPackages; [
    clr
    rocthrust
    rocprim
    hipsparse
    hipblas
  ]));

  propagatedBuildInputs = [
    psutil
    ray
    pandas
    pyarrow
    sentencepiece
    numpy
    torch-bin
    transformers
    xformers
    fastapi
    uvicorn
    pydantic
    aioprometheus
  ] ++ uvicorn.optional-dependencies.standard
    ++ aioprometheus.optional-dependencies.starlette;

  pythonImportsCheck = [ "vllm" ];

  meta = with lib; {
    description = "A high-throughput and memory-efficient inference and serving engine for LLMs";
    changelog = "https://github.com/vllm-project/vllm/releases/tag/v${version}";
    homepage = "https://github.com/vllm-project/vllm";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    broken = !cudaSupport && !rocmSupport;
  };
}
