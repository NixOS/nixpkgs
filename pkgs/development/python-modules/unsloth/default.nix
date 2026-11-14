{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  accelerate,
  bitsandbytes,
  certifi,
  datasets,
  diffusers,
  hf-transfer,
  huggingface-hub,
  numpy,
  packaging,
  peft,
  protobuf,
  psutil,
  sentencepiece,
  torch,
  torchvision,
  tqdm,
  transformers,
  triton,
  trl,
  unsloth-zoo,
  xformers,

  # tests
  cudaPackages,
  python,
  gcc,
}:

buildPythonPackage (finalAttrs: {
  pname = "unsloth";
  version = "2026.11.2";
  pyproject = true;

  # Upstream no longer publishes sdists on PyPI.
  # The GitHub release tags follow the Studio version, not the Python package one.
  src = fetchFromGitHub {
    owner = "unslothai";
    repo = "unsloth";
    tag = "v0.1.915-beta";
    hash = "sha256-LUkTs09WKZY4agfGqim4O5ZDCyimJ9HgjEnufyArg4I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.1.0" "setuptools" \
      --replace-fail "setuptools==82.0.1" "setuptools" \
      --replace-fail "setuptools-scm==9.2.2" "setuptools-scm"
  ''
  # The GitHub tag does not match the package version, make sure they agree.
  + ''
    grep -qF '__version__ = "${finalAttrs.version}"' unsloth/_version.py
  ''
  # The AGPL-licensed CLI and Studio need a separately built web frontend and
  # are not part of the packaged Python library.
  + ''
    rm -rf unsloth_cli studio unsloth-cli.py cli.py
  ''
  # Drop the entry point after removing the CLI package above.
  + ''
    sed -i '/^\[project\.scripts\]/,/^$/d' pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "certifi"
  ];

  # On GitHub, the library dependencies live in the `huggingface` extra, while the
  # base dependencies are the ones of the CLI and Studio, which we do not package.
  pythonRemoveDeps = [
    "click"
    "json5"
    "nest-asyncio"
    "pydantic"
    "pyyaml"
    "rich"
    "structlog"
    "typer"
  ];

  dependencies = [
    accelerate
    bitsandbytes
    certifi
    datasets
    diffusers
    hf-transfer
    huggingface-hub
    numpy
    packaging
    peft
    protobuf
    psutil
    sentencepiece
    torch
    torchvision
    tqdm
    transformers
    triton
    trl
    unsloth-zoo
    xformers
  ];

  # Tests require a GPU
  doCheck = false;

  # Without a GPU, unsloth falls back to its CPU backend.
  pythonImportsCheck = [ "unsloth" ];

  passthru.tests =
    let
      cuda =
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

            sys.path.insert(0, "${finalAttrs.src}")

            # Execute the test file from the Nix store at runtime (no eval-time IFD).
            runpy.run_path(
                "${finalAttrs.src}/tests/qlora/test_unsloth_qlora_train_and_merge.py",
                run_name="__main__"
            )
          '';
    in
    {
      qlora-train-and-merge = cuda;
    };

  meta = {
    description = "Finetune Llama 3.3, DeepSeek-R1 & Reasoning LLMs 2x faster with 70% less memory";
    homepage = "https://github.com/unslothai/unsloth";
    changelog = "https://github.com/unslothai/unsloth/releases/tag/${finalAttrs.src.tag}";
    # Many modules of the core library are now AGPL-3.0-only.
    license = with lib.licenses; [
      asl20
      agpl3Only
    ];
    maintainers = with lib.maintainers; [ hoh ];
  };
})
