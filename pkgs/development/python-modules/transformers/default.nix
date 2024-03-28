{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
# propagated build inputs
, filelock
, huggingface-hub
, numpy
, protobuf
, packaging
, pyyaml
, regex
, requests
, tokenizers
, safetensors
, tqdm
# optional dependencies
, diffusers
, scikit-learn
, tensorflow
, onnxconverter-common
, opencv4
, tf2onnx
, torch
, accelerate
, faiss
, datasets
, jax
, jaxlib
, flax
, optax
, ftfy
, onnxruntime
, onnxruntime-tools
, cookiecutter
, sagemaker
, fairscale
, optuna
, ray
, pydantic
, uvicorn
, fastapi
, starlette
, librosa
, phonemizer
, torchaudio
, pillow
, timm
, torchvision
, av
, sentencepiece
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.39.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "transformers";
    rev = "refs/tags/v${version}";
    hash = "sha256-OzuiKzhgI9eRTPq3l7x4aw3fxvCe4080pK1RKzcC1RQ=";
  };

  propagatedBuildInputs = [
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

  passthru.optional-dependencies =
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
    sklearn = [
      scikit-learn
    ];
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
    retrieval = [ faiss datasets ];
    flax = [ jax jaxlib flax optax ];
    tokenizers = [
      tokenizers
    ];
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
    modelcreation = [
      cookiecutter
    ];
    sagemaker = [
      sagemaker
    ];
    deepspeed = [
      # deepspeed
      accelerate
    ];
    fairscale = [ fairscale ];
    optuna = [ optuna ];
    ray = [ ray ] ++ ray.optional-dependencies.tune-deps;
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
      # decord
      av
    ];
    sentencepiece = [ sentencepiece protobuf ];
  };


  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [
    "transformers"
  ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "Natural Language Processing for TensorFlow 2.0 and PyTorch";
    mainProgram = "transformers-cli";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pashashocky happysalada ];
  };
}
