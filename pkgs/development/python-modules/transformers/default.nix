{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  filelock,
  huggingface-hub,
  numpy,
  protobuf,
  packaging,
  pyyaml,
  regex,
  safetensors,
  tokenizers,
  tqdm,
  typer-slim,

  # optional-dependencies
  # sklearn
  scikit-learn,
  # torch
  torch,
  accelerate,
  # deepspeed
  # deepspeed,
  # codecarbon
  # codecarbon,
  # retrieval
  faiss,
  datasets,
  # ja
  fugashi,
  ipadic,
  sudachipy,
  # sudachidict_core,
  # unidic_lite,
  unidic,
  # rhoknp,
  # sagemaker
  sagemaker,
  # optuna
  optuna,
  # ray
  ray,
  # kernels
  kernels,
  # serving
  openai,
  pydantic,
  uvicorn,
  fastapi,
  starlette,
  rich,
  # audio
  librosa,
  # pyctcdecode,
  phonemizer,
  # kenlm,
  torchaudio,
  # vision
  pillow,
  # timm
  timm,
  # torch-vision
  torchvision,
  # video
  av,
  # num2words
  num2words,
  # sentencepiece
  sentencepiece,
  # tiktoken
  tiktoken,
  blobfile,
  # mistral-common
  mistral-common,
  # chat_template
  jinja2,
  jmespath,
  # quality
  ruff,
  gitpython,
  urllib3,
  libcst,
  # opentelemetry
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  opentelemetry-sdk,
}:

buildPythonPackage (finalAttrs: {
  pname = "transformers";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "transformers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DMm85M47hMWhqbwY3k3F5nbkbctM23K6wnmIUa2O43g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    huggingface-hub
    numpy
    packaging
    pyyaml
    regex
    safetensors
    tokenizers
    tqdm
    typer-slim
  ];

  optional-dependencies = lib.fix (self: {
    ja = [
      fugashi
      ipadic
      # unidic_lite
      unidic
      # rhoknp
      sudachipy
      # sudachidict_core
    ];
    sklearn = [ scikit-learn ];
    torch = [
      torch
      accelerate
    ];
    accelerate = [ accelerate ];
    retrieval = [
      faiss
      datasets
    ];
    sagemaker = [ sagemaker ];
    deepspeed = [
      # deepspeed
    ]
    ++ self.accelerate;
    optuna = [ optuna ];
    ray = [ ray ] ++ ray.optional-dependencies.tune;
    kernels = [ kernels ];
    codecarbon = [
      # codecarbon
    ];
    integrations = self.kernels ++ self.optuna ++ self.codecarbon ++ self.ray;
    serving = [
      openai
      pydantic
      uvicorn
      fastapi
      starlette
      rich
    ]
    ++ self.torch;
    audio = [
      torchaudio
      librosa
      # pyctcdecode
      phonemizer
      # kenlm
    ];
    vision = [
      torchvision
      pillow
    ];
    timm = [ timm ];
    video = [ av ];
    num2words = [ num2words ];
    sentencepiece = [
      sentencepiece
      protobuf
    ];
    tiktoken = [
      tiktoken
      blobfile
    ];
    mistral-common = [ mistral-common ] ++ mistral-common.optional-dependencies.image;
    chat_template = [
      jinja2
      jmespath
    ];
    quality = [
      datasets
      ruff
      gitpython
      urllib3
      libcst
      rich
    ];
    benchmark = [
      # optimum-benchmark
    ];
    open-telemetry = [
      opentelemetry-api
      opentelemetry-exporter-otlp
      opentelemetry-sdk
    ];
  });

  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [ "transformers" ];

  meta = {
    homepage = "https://github.com/huggingface/transformers";
    description = "Natural Language Processing for TensorFlow 2.0 and PyTorch";
    mainProgram = "transformers-cli";
    changelog = "https://github.com/huggingface/transformers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      GaetanLepage
      pashashocky
      happysalada
    ];
  };
})
