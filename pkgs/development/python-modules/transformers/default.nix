{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  numpy,
  packaging,
  pyyaml,
  regex,
  safetensors,
  tokenizers,
  tqdm,
  typer,

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
  protobuf,
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
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "transformers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vus4Y+1QXUNqwBO1ZK0gWd+sJBPwrqWW7O2sn0EBvno=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "typer-slim" "typer"
  '';

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    numpy
    packaging
    pyyaml
    regex
    safetensors
    tokenizers
    tqdm
    typer
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
    chat-template = [
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
