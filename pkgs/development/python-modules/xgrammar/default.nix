{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  pybind11,
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
  version = "0.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = "xgrammar";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ohsoc3g5XUp9vSXxyOGj20wXzCXZC02ktHYVQjDqNeM=";
  };

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  dependencies =
    [
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

  disabledTests = [
    # You are trying to access a gated repo.
    "test_grammar_compiler"
    "test_grammar_matcher"
    "test_grammar_matcher_ebnf"
    "test_grammar_matcher_json"
    "test_grammar_matcher_json_schema"
    "test_grammar_matcher_tag_dispatch"
    "test_regex_converter"
    "test_tokenizer_info"

    # Torch not compiled with CUDA enabled
    "test_token_bitmask_operations"
  ];

  pythonImportsCheck = [ "xgrammar" ];

  meta = {
    description = "Efficient, Flexible and Portable Structured Generation";
    homepage = "https://xgrammar.mlc.ai";
    changelog = "https://github.com/mlc-ai/xgrammar/releases/tag/v${version}";
    license = lib.licenses.asl20;
  };
}
