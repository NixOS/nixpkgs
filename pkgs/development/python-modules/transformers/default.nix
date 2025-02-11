{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  requests,
  tokenizers,
  safetensors,
  tqdm,

  # optional-dependencies
  diffusers,
  scikit-learn,
  tensorflow,
  onnxconverter-common,
  opencv4,
  tf2onnx,
  torch,
  accelerate,
  faiss,
  datasets,
  jax,
  jaxlib,
  flax,
  optax,
  ftfy,
  onnxruntime,
  onnxruntime-tools,
  cookiecutter,
  sagemaker,
  fairscale,
  optuna,
  ray,
  pydantic,
  uvicorn,
  fastapi,
  starlette,
  librosa,
  phonemizer,
  torchaudio,
  pillow,
  timm,
  torchvision,
  av,
  sentencepiece,
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.48.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "transformers";
    tag = "v${version}";
    hash = "sha256-gDPJx/kgFa8KCoX8XCMtFrSY/z2as22yDSNEW3UDm/0=";
  };

  patches = [
    # Remove on the next major version bump
    (fetchpatch {
      url = "https://github.com/huggingface/transformers/commit/db864b5526d56fd99143619abff969bfcb5596d5.patch?full_index=1";
      name = "dont-import-torch-distributed-if-not-available.patch";
      hash = "sha256-XOraJmSt9Rp/oNiil6vDUBqZhd8MDbA0nz1Tx16Mk14=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    filelock
    huggingface-hub
    numpy
    packaging
    pyyaml
    regex
    requests
    tokenizers
    safetensors
    tqdm
  ];

  optional-dependencies =
    let
      audio = [
        librosa
        # pyctcdecode
        phonemizer
        # kenlm
      ];
      vision = [ pillow ];
    in
    {
      agents = [
        diffusers
        accelerate
        datasets
        torch
        sentencepiece
        opencv4
        pillow
      ];
      ja = [
        # fugashi
        # ipadic
        # rhoknp
        # sudachidict_core
        # sudachipy
        # unidic
        # unidic_lite
      ];
      sklearn = [ scikit-learn ];
      tf = [
        tensorflow
        onnxconverter-common
        tf2onnx
        # tensorflow-text
        # keras-nlp
      ];
      torch = [
        torch
        accelerate
      ];
      retrieval = [
        faiss
        datasets
      ];
      flax = [
        jax
        jaxlib
        flax
        optax
      ];
      tokenizers = [ tokenizers ];
      ftfy = [ ftfy ];
      onnxruntime = [
        onnxruntime
        onnxruntime-tools
      ];
      onnx = [
        onnxconverter-common
        tf2onnx
        onnxruntime
        onnxruntime-tools
      ];
      modelcreation = [ cookiecutter ];
      sagemaker = [ sagemaker ];
      deepspeed = [
        # deepspeed
        accelerate
      ];
      fairscale = [ fairscale ];
      optuna = [ optuna ];
      ray = [ ray ] ++ ray.optional-dependencies.tune;
      # sigopt = [ sigopt ];
      # integrations = ray ++ optuna ++ sigopt;
      serving = [
        pydantic
        uvicorn
        fastapi
        starlette
      ];
      audio = audio;
      speech = [ torchaudio ] ++ audio;
      torch-speech = [ torchaudio ] ++ audio;
      tf-speech = audio;
      flax-speech = audio;
      timm = [ timm ];
      torch-vision = [ torchvision ] ++ vision;
      # natten = [ natten ];
      # codecarbon = [ codecarbon ];
      video = [
        av
      ];
      sentencepiece = [
        sentencepiece
        protobuf
      ];
    };

  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [ "transformers" ];

  meta = {
    homepage = "https://github.com/huggingface/transformers";
    description = "Natural Language Processing for TensorFlow 2.0 and PyTorch";
    mainProgram = "transformers-cli";
    changelog = "https://github.com/huggingface/transformers/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pashashocky
      happysalada
    ];
  };
}
