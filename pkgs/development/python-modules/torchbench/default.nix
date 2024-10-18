{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  accelerate,
  boto3,
  beautifulsoup4,
  distro,
  iopath,
  monkeytype,
  numpy,
  opencv4,
  patch,
  psutil,
  py-cpuinfo,
  pynvml,
  pytest,
  pytest-benchmark,
  pyyaml,
  requests,
  submitit,
  tabulate,
  transformers,
}:

buildPythonPackage {
  pname = "torchbench";
  version = "0-unstable-2024-10-17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "benchmark";
    rev = "00c9b9ed61b70425e6875e0c4d6c5ad18a1b1d4c";
    hash = "sha256-Sc50BvIQWVZgotOOC1sG3qjVHRbqxDcLH4xA+Vt/T3o=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    accelerate
    boto3
    beautifulsoup4
    distro
    iopath
    monkeytype
    numpy
    opencv4
    patch
    psutil
    py-cpuinfo
    pynvml
    pytest
    pytest-benchmark
    pyyaml
    requests
    submitit
    tabulate
    transformers
  ];

  pythonImportsCheck = [
    "torchbenchmark"
  ];

  meta = {
    description = "TorchBench is a collection of open source benchmarks used to evaluate PyTorch performance";
    homepage = "https://github.com/pytorch/benchmark";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
