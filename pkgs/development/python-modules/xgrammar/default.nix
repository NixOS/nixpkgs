{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  ninja,
  pip,
  pytestCheckHook,
  python3,
  pybind11,
  pydantic,
  sentencepiece,
  tiktoken,
  torch,
  transformers,
  triton,
}:

buildPythonPackage rec {
  pname = "xgrammar";
  version = "0.1.11";
  format = "other";

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-q5d8/9S9p9M8HlCIernT9IwPEDnbC1R9nGsLuS15RXY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ pip ];

  dontUseNinjaInstall = true;

  installPhase = ''
    runHook preInstall

    cd ../python
    ${python3.interpreter} -m pip install --prefix=$out .
    cd ..

    runHook postInstall
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd tests/python/
  '';

  disabledTests = [
    # You are trying to access a gated repo.
    "test_grammar_compiler"
    "test_grammar_matcher"
    "test_grammar_matcher_ebnf"
    "test_grammar_matcher_json"
    "test_grammar_matcher_json_schema"
    "test_grammar_matcher_tag_dispatch"
    "test_regex_converter"
    # Torch not compiled with CUDA enabled
    "test_token_bitmask_operations"
    # You are trying to access a gated repo.
    "test_tokenizer_info"
  ];

  pythonImportsCheck = [ "xgrammar" ];

  dependencies = [
    pybind11
    pydantic
    sentencepiece
    tiktoken
    torch
    transformers
    triton
  ];

  meta = with lib; {
    description = "Efficient, Flexible and Portable Structured Generation";
    homepage = "https://xgrammar.mlc.ai";
    license = licenses.asl20;
  };
}
