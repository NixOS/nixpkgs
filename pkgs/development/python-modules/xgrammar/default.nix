{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  nanobind,
  scikit-build-core,

  # dependencies
  mlx-lm,
  pydantic,
  sentencepiece,
  tiktoken,
  torch,
  transformers,
  triton,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "xgrammar";
  version = "0.1.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = "xgrammar";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-K+GCHuWKF449JaGWr7FQrDeJS3pxmVKnGf68L53LrK0=";
  };

  patches = [
    ./0001-fix-find-nanobind-from-python-module.patch
  ];

  build-system = [
    cmake
    ninja
    nanobind
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    pydantic
    sentencepiece
    tiktoken
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
    writableTmpDirAsHomeHook
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux (toString [
    # xgrammar hardcodes -flto=auto while using static linking, which can cause linker errors without this additional flag.
    "-ffat-lto-objects"
  ]);

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

  pythonImportsCheck = [ "xgrammar" ];

  meta = {
    description = "Efficient, Flexible and Portable Structured Generation";
    homepage = "https://xgrammar.mlc.ai";
    changelog = "https://github.com/mlc-ai/xgrammar/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    badPlatforms = [
      # error: ‘operator delete’ called on unallocated object ‘result’ [-Werror=free-nonheap-object]
      "aarch64-linux"
    ];
  };
}
