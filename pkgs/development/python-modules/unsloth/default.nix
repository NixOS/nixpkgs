{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  bitsandbytes,
  numpy,
  packaging,
  torch,
  unsloth-zoo,
  xformers,
  tyro,
  transformers,
  datasets,
  sentencepiece,
  tqdm,
  accelerate,
  trl,
  peft,
  protobuf,
  huggingface-hub,
  hf-transfer,
  diffusers,
  torchvision,

  # tests
  fetchFromGitHub,
  cudaPackages,
  python,
  gcc,
}:

let
  # Test files are absent from the PyPI package, so we fetch them separately.
  testSrc = fetchFromGitHub {
    owner = "unslothai";
    repo = "unsloth";
    rev = "cb78f0e83dc2d61fb1571b6e904eb2f064510d63";
    hash = "sha256-0oR3m8jnjSdfjH+NslW6SsVj+0cQ4VUhKXZ38U/VBy0=";
    # Keep only the tests directory, use the PyPI package for everything else.
    postFetch = ''
      mv $out/tests $TMPDIR/tests
      rm -rf $out/*
      mv $TMPDIR/tests $out/tests
    '';
  };
in

buildPythonPackage rec {
  pname = "unsloth";
  version = "2025.9.4";
  pyproject = true;

  # Tags on the GitHub repo don't match
  src = fetchPypi {
    pname = "unsloth";
    inherit version;
    hash = "sha256-aT/RS48hBMZT1ab1Rx1lpSMi6yyEzJCASzDAP0d6ixA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    bitsandbytes
    numpy
    packaging
    torch
    unsloth-zoo
    xformers
    tyro
    transformers
    datasets
    sentencepiece
    tqdm
    accelerate
    trl
    peft
    protobuf
    huggingface-hub
    hf-transfer
    diffusers
    torchvision
  ];

  # pyproject.toml requires an obsolete version of protobuf,
  # but it is not used.
  # Upstream issue: https://github.com/unslothai/unsloth-zoo/pull/68
  pythonRelaxDeps = [
    "datasets"
    "protobuf"
    "transformers"
    "torch"
  ];

  # The source repository contains no test
  doCheck = false;

  # Importing requires a GPU, else the following error is raised:
  # NotImplementedError: Unsloth: No NVIDIA GPU found? Unsloth currently only supports GPUs!
  dontUsePythonImportsCheck = true;

  passthru.tests = {
    qlora-train-and-merge =
      # FIXME: Replace python3.pkgs with python3Packages once possible, as to unbeak splicing.
      # Cf. https://github.com/NixOS/nixpkgs/pull/394838#issuecomment-3319287038
      cudaPackages.writeGpuTestPython.override { python3Packages = python.pkgs; }
        {
          libraries = ps: [
            ps.unsloth
            ps.unsloth-zoo
          ];
          # In-derivation test would require fetching the model from hugging-face which will not be trivial.
          gpuCheckArgs.meta.broken = true;
        }
        # Triton JIT requires a C compiler at runtime and imports files from the test directory.
        ''
          import os, sys, runpy

          os.environ["CC"]  = "${lib.getExe' gcc "cc"}";
          os.environ["CXX"] = "${lib.getExe' gcc "cxx"}";

          sys.path.insert(0, "${testSrc}")

          # Execute the test file from the Nix store at runtime (no eval-time IFD).
          runpy.run_path(
              "${testSrc}/tests/qlora/test_unsloth_qlora_train_and_merge.py",
              run_name="__main__"
          )
        '';
  };

  meta = {
    description = "Finetune Llama 3.3, DeepSeek-R1 & Reasoning LLMs 2x faster with 70% less memory";
    homepage = "https://github.com/unslothai/unsloth";
    changelog = "https://github.com/unslothai/unsloth/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
