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
  version = "0.1.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = "xgrammar";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-asyxJsrsbfFNh1pLBDzM4kdmunQp7/mTDw3L8KuZf4g=";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  NIX_CFLAGS_COMPILE = toString [
    # xgrammar hardcodes -flto=auto while using static linking, which can cause linker errors without this additional flag.
    "-ffat-lto-objects"
  ];

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

      # clang++: error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin'
      # idem for 'x86_64-apple-darwin'
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
