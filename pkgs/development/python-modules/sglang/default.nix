{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  versionCheckHook,

  aiohttp,
  anthropic,
  apache-tvm-ffi,
  blobfile,
  build,
  buildPackages,
  cargo,
  compressed-tensors,
  cuda-bindings,
  datasets,
  easydict,
  einops,
  fastapi,
  flash-attn-4,
  flashinfer,
  gguf,
  interegular,
  ipython,
  kernels,
  llguidance,
  mistral-common,
  modelscope,
  msgspec,
  ninja,
  numpy,
  nvidia-cutlass-dsl,
  nvidia-ml-py,
  openai,
  openai-harmony,
  orjson,
  outlines,
  packaging,
  partial-json-parser,
  pillow,
  prometheus-client,
  psutil,
  pybase64,
  pydantic,
  python-multipart,
  pyzmq,
  quack-kernels,
  requests,
  rustc,
  rustPlatform,
  scipy,
  sentencepiece,
  setproctitle,
  setuptools,
  setuptools-rust,
  setuptools-scm,
  sglang-kernel,
  sgl-deep-gemm,
  smg-grpc-servicer,
  soundfile,
  tiktoken,
  tilelang,
  timm,
  tokenspeed-mla,
  torch,
  torch-memory-saver,
  torchao,
  torchaudio,
  torchcodec,
  torchvision,
  tqdm,
  transformers,
  uvicorn,
  uvloop,
  watchfiles,
  xgrammar,
}:
buildPythonPackage (finalAttrs: {
  pname = "sglang";
  version = "0.5.12.post1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sgl-project";
    repo = "sglang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ce7w5x4RBNZYTLduGgDi6Pr1y3CehoTQmOLkGqvOok=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  patches = [
    ./flashinfer.patch
  ];

  postPatch = ''
    chmod u+w ../rust/sglang-grpc
    cp ${./Cargo.lock} ../rust/sglang-grpc/Cargo.lock
  '';

  cargoRoot = "../rust/sglang-grpc";

  # rust/sglang-grpc
  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  build-system = [
    setuptools
    setuptools-rust
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    anthropic
    apache-tvm-ffi
    blobfile
    build
    compressed-tensors
    cuda-bindings
    datasets
    easydict
    einops
    fastapi
    flash-attn-4
    flashinfer
    gguf
    interegular
    ipython
    kernels
    llguidance
    mistral-common
    modelscope
    msgspec
    ninja
    numpy
    nvidia-cutlass-dsl
    nvidia-ml-py
    openai
    openai-harmony
    orjson
    outlines
    packaging
    partial-json-parser
    pillow
    prometheus-client
    psutil
    pybase64
    pydantic
    python-multipart
    pyzmq
    quack-kernels
    requests
    scipy
    sentencepiece
    setproctitle
    sglang-kernel
    sgl-deep-gemm
    smg-grpc-servicer
    soundfile
    tiktoken
    tilelang
    timm
    tokenspeed-mla
    torch
    torch-memory-saver
    torchao
    torchaudio
    torchcodec
    torchvision
    tqdm
    transformers
    uvicorn
    uvloop
    watchfiles
    xgrammar
  ];

  pythonRemoveDeps = [
    "cuda-python"
    "py-spy"
  ];

  pythonRelaxDeps = [
    "apache-tvm-ffi"
    "blobfile"
    "llguidance"
    "nvidia-cutlass-dsl"
    "openai"
    "openai-harmony"
    "sgl-deep-gemm"
    "sglang-kernel"
    "tilelang"
    "timm"
    "tokenspeed_mla"
    "transformers"
    "xgrammar"

    "outlines"
  ];

  pythonImportsCheck = [ "sglang" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  env.PROTOC = lib.getExe buildPackages.protobuf;

  meta = {
    description = "High-performance serving framework for large language models and multimodal models";
    homepage = "https://www.sglang.io/";
    downloadPage = "https://github.com/sgl-project/sglang/releases";
    changelog = "https://github.com/sgl-project/sglang/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "sglang";
  };
})
