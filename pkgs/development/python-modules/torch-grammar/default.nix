{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, sentencepiece
, torch
, transformers
}:

buildPythonPackage rec {
  pname = "torch-grammar";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "torch_grammar";
    inherit version;
    hash = "sha256-bVmv/OjLk3r20NvpYFr8r6IoOzJwq2DNMKRFVHm7dTA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    sentencepiece
    torch
    transformers
  ];

  pythonImportsCheck = [ "torch_grammar" ];

  meta = with lib; {
    description = "Restrict LLM generations to a context-free grammar";
    homepage = "https://pypi.org/project/torch-grammar/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
