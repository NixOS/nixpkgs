{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  setuptools,

  # dependencies
  distro,
  numba,
  numpy,
  nvidia-ml-py,
  psutil,
  py-cpuinfo,
  pyyaml,
  timm,
  torch,
  torchvision,

  # optional-dependencies
  transformers,

  # tests
  expecttest,
  pytest-benchmark,
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  common-updater-scripts,
  curl,
  git,
  writeShellScript,
}:

let
  # Models that need neither network access nor downloaded inputs, checked on the CPU
  offlineModels = [
    "BERT_pytorch"
    "dcgan"
    "functorch_dp_cifar10"
    "hf_Bert"
    "hf_BigBird"
    "hf_Reformer"
    "hf_Whisper"
    "lennard_jones"
    "llama"
    "maml"
    "microbench_unbacked_tolist_sum"
    "nanogpt"
    "nvidia_deeprecommender"
    "phlippe_resnet"
    "pyhpc_equation_of_state"
    "pyhpc_isoneutral_mixing"
    "pyhpc_turbulent_kinetic_energy"
    "timm_vovnet"
    "tts_angular"
  ];
in
buildPythonPackage (finalAttrs: {
  pname = "torchbenchmark";
  version = "0-unstable-2026-03-06";
  pyproject = true;
  __structuredAttrs = true;

  # PyTorch pins the TorchBench commit its CI runs against; this is the pin for torch 2.14
  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "benchmark";
    rev = "0fff8bf35400ec7b733d5080628fc79551205e36";
    hash = "sha256-SKXkSAXSU/hHlZzgN8vDShZAeKG6YmB0X1+Hs6YgURI=";
  };

  postPatch =
    # The distribution is called `torchbench`, which is the name of an unrelated PyPI project
    # (python3Packages.torchbench); use the import name instead so the two don't collide.
    ''
      substituteInPlace setup.py \
        --replace-fail 'name="torchbench",' 'name="torchbenchmark",'
    ''
    # The remaining substitutions are proposed upstream in
    # https://github.com/pytorch/benchmark/pull/2716.
    # Ship the model sources and their data files (metadata.yaml, patches, ...), not only the
    # directories with an `__init__.py`:
    # https://github.com/pytorch/benchmark/pull/2716/commits/d6b7ba2830efc19e02f4d7431b7ec4cdd0e3632e
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          'from setuptools import find_packages, setup' \
          'from setuptools import find_namespace_packages, setup' \
        --replace-fail \
          'packages=find_packages(include=["torchbenchmark*", "userbenchmark*"]),' \
          'packages=find_namespace_packages(include=["torchbenchmark*", "userbenchmark*"]), package_data={"": ["*"]},'
    ''
    # `torchbenchmark` imports `utils` from the directory above it, which is the repository root
    # in a checkout but `site-packages` once installed. It only needs `get_pkg_versions`, which
    # `torchbenchmark.util.env_check` duplicates, and `TORCH_DEPS`, for `install.py`:
    # https://github.com/pytorch/benchmark/pull/2716/commits/2eae9eb23803e96fac45230d26f11125804aa72a
    + ''
      substituteInPlace torchbenchmark/__init__.py \
        --replace-fail \
          'from utils import get_pkg_versions, TORCH_DEPS' \
          'from .util.env_check import get_pkg_versions; TORCH_DEPS = ["numpy", "torch", "torchvision", "torchaudio"]'
    ''
    # distutils left the standard library in Python 3.12; it only imports through setuptools' shim:
    # https://github.com/pytorch/benchmark/pull/2716/commits/fd52829ccd6749cf42598823fa3668332ba5ba86
    + ''
      substituteInPlace torchbenchmark/util/backends/torchdynamo.py \
        --replace-fail 'import distutils.util' "" \
        --replace-fail 'type=distutils.util.strtobool,' 'type=torchbenchmark.str_to_bool,'
    ''
    # Since Python 3.13 (PEP 667), names `exec` binds inside a function are invisible to a later
    # `eval`, so every basic Hugging Face model fails with a NameError:
    # https://github.com/pytorch/benchmark/pull/2716/commits/b3476adb5146d1fd3136fcbfe9daa774176c8be9
    + ''
      substituteInPlace torchbenchmark/util/framework/huggingface/basic_configs.py \
        --replace-fail \
          'exec(f"from transformers import {config_cls_name}")' \
          'config_cls_namespace = {config_cls_name: getattr(transformers, config_cls_name)}' \
        --replace-fail \
          'config = eval(HUGGINGFACE_MODELS[model_name][2])' \
          'config = eval(HUGGINGFACE_MODELS[model_name][2], config_cls_namespace)'
    ''
    # The model analyzer, which records GPU peak memory, skips GPUs it has no cores-per-SM entry
    # for, failing with "No GPU found" on Blackwell; the entries follow NVIDIA's cuda-samples
    # (Common/helper_cuda.h):
    # https://github.com/pytorch/benchmark/pull/2716/commits/a33afbd24745191b3441ccda76a2c85a0edb1e1b
    + ''
      substituteInPlace torchbenchmark/_components/model_analyzer/tb_dcgm_types/gpu_device.py \
        --replace-fail \
          '(9, 0): 128,  # Hopper' \
          '(9, 0): 128, (10, 0): 128, (10, 1): 128, (10, 3): 128, (10, 7): 128, (11, 0): 128, (12, 0): 128, (12, 1): 128,'
    ''
    # Userbenchmarks write their results next to the installed package by default; upstream falls
    # back to the working directory when that is read-only, which it always is here:
    # https://github.com/pytorch/benchmark/pull/2716/commits/3a005ce2ad0c4d669a23f05bcdd104eaaa9936c2
    + ''
      substituteInPlace userbenchmark/utils.py \
        --replace-fail \
          'target_dir = current_dir.parent.joinpath(USERBENCHMARK_OUTPUT_PREFIX, bm_name)' \
          'target_dir = Path.cwd().joinpath(USERBENCHMARK_OUTPUT_PREFIX, bm_name)'
    '';

  build-system = [ setuptools ];

  dependencies = [
    distro
    numba
    numpy
    nvidia-ml-py
    psutil
    py-cpuinfo
    pyyaml
    timm
    torch
    torchvision
  ];

  optional-dependencies = {
    huggingface = [ transformers ];
  };

  # The entry points upstream runs from a checkout
  postInstall = ''
    for script in run run_benchmark; do
      install -Dm755 "$script.py" "$out/bin/torchbench-''${script//_/-}"
      sed -i '1i #!/usr/bin/env python3' "$out/bin/torchbench-''${script//_/-}"
    done
  '';

  pythonImportsCheck = [
    "torchbenchmark"
    "torchbenchmark.models"
    "userbenchmark"
  ];

  nativeCheckInputs = [
    expecttest
    pytest-benchmark
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.huggingface;

  preCheck = ''
    mv torchbenchmark/_components/test component_tests
    rm -r torchbenchmark userbenchmark utils
  '';

  enabledTestPaths = [
    "component_tests"
    "test.py"
  ];

  # test.py generates tests for every model, most of which need network access or inputs that
  # upstream's install.py downloads
  enabledTests = [
    "TestBenchmarkWorker"
    "TestParseFunction"
    "TestSubprocessExceptions"
    "TestSubprocessRPC"
  ]
  ++ lib.concatMap (
    model:
    map (test: "test_${model}_${test}_cpu") [
      "check_device"
      "eval"
      "example"
      "train"
    ]
  ) offlineModels;

  # Upstream's conftest.py otherwise refuses to run on a machine not tuned for benchmarking
  pytestFlags = [ "--ignore_machine_config" ];

  # Runs models through both entry points on a GPU, in train and eval mode
  passthru.gpuCheck = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-gpu-check";
    inherit (finalAttrs) version;
    __structuredAttrs = true;

    requiredSystemFeatures = [ "cuda" ];

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      (python.withPackages (
        _: [ finalAttrs.finalPackage ] ++ finalAttrs.passthru.optional-dependencies.huggingface
      ))
      writableTmpDirAsHomeHook
    ];

    installPhase = ''
      touch "$out"
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      python -c 'import torch; assert torch.cuda.is_available(), "no CUDA device"'

      for model in hf_Bert timm_vovnet; do
        for test in train eval; do
          torchbench-run "$model" --device cuda --test "$test" --bs 4
        done
      done

      # torch.compile through the dynamo backend
      torchbench-run nanogpt --device cuda --test eval --torchdynamo inductor

      # test_bench records errors as metric values instead of failing. Its default mode reads GPU
      # memory through NVML, which GPUs with unified memory (e.g. GB10) don't support, so check
      # accuracy instead.
      torchbench-run-benchmark test_bench --accuracy \
        --models phlippe_resnet,nanogpt --device cuda --test train,eval --output metrics.json
      python - <<'EOF'
      import json

      metrics = json.load(open("metrics.json"))["metrics"]
      assert len(metrics) == 4 and set(metrics.values()) == {"pass"}, metrics
      EOF

      runHook postInstallCheck
    '';
  };

  passthru.updateScript = writeShellScript "update-torchbenchmark" ''
    set -euo pipefail
    export PATH="${
      lib.makeBinPath [
        common-updater-scripts
        curl
        git
      ]
    }:$PATH"

    # Follow the TorchBench commit PyTorch's CI pins for the packaged torch release
    rev="$(curl -fsSL "https://raw.githubusercontent.com/pytorch/pytorch/v${torch.version}/.ci/docker/ci_commit_pins/torchbench.txt")"

    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    git -C "$tmp" init --quiet
    git -C "$tmp" fetch --quiet --depth=1 "${finalAttrs.src.gitRepoUrl}" "$rev"
    date="$(git -C "$tmp" show --no-patch --format=%cs FETCH_HEAD)"

    update-source-version "$UPDATE_NIX_ATTR_PATH" "0-unstable-$date" --rev="$rev"
  '';

  meta = {
    description = "Collection of open source benchmarks used to evaluate PyTorch performance";
    homepage = "https://github.com/pytorch/benchmark";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
    mainProgram = "torchbench-run";
  };
})
