{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  apache-tvm-ffi,
  cmake,
  ninja,
  scikit-build-core,

  # dependencies
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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = "xgrammar";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-h9ovM/HbbkrxHGlJNn8eEisD5fnfRGCwoSOwc6HgpVQ=";
  };

  build-system = [
    apache-tvm-ffi
    cmake
    ninja
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    numpy
    pydantic
    torch
    transformers
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    triton
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    mlx-lm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sentencepiece
    tiktoken
    writableTmpDirAsHomeHook
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_CFLAGS_COMPILE = toString [
      # xgrammar hardcodes -flto=auto while using static linking, which can cause linker errors without this additional flag.
      "-ffat-lto-objects"
    ];
  };

  disabledTests = [
    # You are trying to access a gated repo.
    "test_grammar_compiler"
    "test_grammar_matcher"
    "test_grammar_matcher_ebnf"
    "test_grammar_matcher_json"
    "test_grammar_matcher_json_schema"
    "test_grammar_matcher_tag_dispatch"
    "test_regex_converter"
    "test_serialize_compiled_grammar_with_hf_tokenizer"
    "test_tokenizer_info"

    # Torch not compiled with CUDA enabled
    "test_token_bitmask_operations"

    # AssertionError
    "test_json_schema_converter"
  ];

  disabledTestPaths = [
    # Requires internet access
    "tests/python/test_structural_tag_converter.py"
  ];

  pythonImportsCheck = [ "xgrammar" ];

  meta = {
    description = "Efficient, Flexible and Portable Structured Generation";
    homepage = "https://xgrammar.mlc.ai";
    changelog = "https://github.com/mlc-ai/xgrammar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
  };
})
