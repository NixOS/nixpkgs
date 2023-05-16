{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
<<<<<<< HEAD
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
, scikit-learn
, tensorflow
, onnxconverter-common
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
=======
, cookiecutter
, filelock
, huggingface-hub
, importlib-metadata
, regex
, requests
, numpy
, packaging
, tensorflow
, sagemaker
, ftfy
, protobuf
, scikit-learn
, pillow
, pyyaml
, torch
, tokenizers
, tqdm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "transformers";
<<<<<<< HEAD
  version = "4.31.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "4.28.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-YbLI/CkRto8G4bV7ijUkB/0cc7LkfNBQxL1iNv8aWW4=";
=======
    hash = "sha256-FmiuWfoFZjZf1/GbE6PmSkeshWWh+6nDj2u2PMSeDk0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    filelock
    huggingface-hub
    numpy
<<<<<<< HEAD
=======
    protobuf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    packaging
    pyyaml
    regex
    requests
    tokenizers
<<<<<<< HEAD
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
    ja = [
      # fugashi
      # ipadic
      # rhoknp
      # sudachidict_core
      # sudachipy
      # unidic
      # unidic_lite
=======
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    ja = [
      # fugashi
      # ipadic
      # unidic_lite
      # unidic
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
    sklearn = [
      scikit-learn
    ];
    tf = [
      tensorflow
<<<<<<< HEAD
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
=======
      # onnxconverter-common
      # tf2onnx
    ];
    torch = [
      torch
    ];
    tokenizers = [
      tokenizers
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    modelcreation = [
      cookiecutter
    ];
    sagemaker = [
      sagemaker
    ];
<<<<<<< HEAD
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
=======
    ftfy = [ ftfy ];
    onnx = [
      # onnxconverter-common
      # tf2onnx
    ];
    vision = [
      pillow
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };


  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [
    "transformers"
  ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "Natural Language Processing for TensorFlow 2.0 and PyTorch";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
<<<<<<< HEAD
    maintainers = with maintainers; [ pashashocky happysalada ];
=======
    maintainers = with maintainers; [ pashashocky ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
