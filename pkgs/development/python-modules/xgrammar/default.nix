{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  scikit-build-core,
  setuptools-scm,

  # dependencies
  apache-tvm-ffi,
  mlx-lm,
  numpy,
  pydantic,
  torch,
  transformers,
  triton,

  # tests
  pytestCheckHook,
  sentencepiece,
  tiktoken,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "xgrammar";
  version = "0.2.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = "xgrammar";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Ff/CLdSjq8ammfci+Eu9hY4433e7csf8EeGu2X9B2rI=";
  };

  build-system = [
    cmake
    ninja
    apache-tvm-ffi
    scikit-build-core
    setuptools-scm
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    apache-tvm-ffi
    numpy
    pydantic
    torch
    transformers
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    triton
  ];

  optional-dependencies = {
    metal = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      mlx-lm
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    sentencepiece
    tiktoken
    writableTmpDirAsHomeHook
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isLinux [
      # xgrammar hardcodes -flto=auto while using static linking, which can cause linker errors without this additional flag.
      "-ffat-lto-objects"
    ]
    ++ lib.optionals stdenv.cc.isGNU [
      # xgrammar builds with -Werror, and GCC 16 emits a false-positive array-bounds warning
      # in cpp/json_schema_converter.cc
      "-Wno-error=array-bounds"
    ]
  );

  disabledTests = [
    # ModuleNotFoundError: No module named 'cohere_melody'
    "melody"
  ];

  pythonImportsCheck = [ "xgrammar" ];

  meta = {
    description = "Efficient, Flexible and Portable Structured Generation";
    homepage = "https://xgrammar.mlc.ai";
    changelog = "https://github.com/mlc-ai/xgrammar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
  };
})
