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
  # hf_xet
  hf-xet,
  # retrieval
  faiss,
  datasets,
  # tokenizers
  # ftfy
  ftfy,
  # modelcreation
  cookiecutter,
  # sagemaker
  sagemaker,
  # optuna
  optuna,
  # ray
  ray,
  # hub-kernels
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
  phonemizer,
  # speech
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
  pandas,
  # torchhub
  importlib-metadata,
}:

buildPythonPackage (finalAttrs: {
  pname = "transformers";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "transformers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ART1ARd+hfC0GQNDa225SWF0zTFUKE4eDxFYbWFaTl8=";
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
      # fugashi
      # ipadic
      # unidic_lite
      # unidic
      # sudachipy
      # sudachidict_core
      # rhoknp
    ];
    sklearn = [ scikit-learn ];
    torch = [
      torch
      accelerate
    ];
    accelerate = [ accelerate ];
    hf_xet = [ hf-xet ];
    retrieval = [
      faiss
      datasets
    ];
    tokenizers = [ tokenizers ];
    ftfy = [ ftfy ];
    modelcreation = [ cookiecutter ];
    sagemaker = [ sagemaker ];
    deepspeed = [
      # deepspeed
    ]
    ++ self.accelerate;
    optuna = [ optuna ];
    ray = [ ray ] ++ ray.optional-dependencies.tune;
    hub-kernels = [ kernels ];
    integrations = self.hub-kernels ++ self.optuna ++ self.ray;
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
      librosa
      # pyctcdecode
      phonemizer
      # kenlm
    ];
    speech = [ torchaudio ] ++ self.audio;
    torch-speech = [ torchaudio ] ++ self.audio;
    vision = [ pillow ];
    timm = [ timm ];
    torch-vision = [ torchvision ] ++ self.vision;
    natten = [
      # natten
    ];
    codecarbon = [
      # codecarbon
    ];
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
      pandas
    ];
    torchhub = [
      filelock
      huggingface-hub
      importlib-metadata
      numpy
      packaging
      protobuf
      regex
      sentencepiece
      torch
      tokenizers
      tqdm
    ];
    benchmark = [
      # optimum-benchmark
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
      pashashocky
      happysalada
    ];
  };
})
