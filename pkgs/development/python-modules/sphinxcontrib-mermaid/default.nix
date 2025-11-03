{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  sphinx,
  setuptools,
  defusedxml,
  myst-parser,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-mermaid";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mgaitan";
    repo = "sphinxcontrib-mermaid";
    rev = version;
    hash = "sha256-OO2fbtB2qLjsIGjRJrBDDRn8dT9qowfU6i8qRBbDRTM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    sphinx
  ];

  optional-dependencies = {
    test = [
      defusedxml
      myst-parser
      sphinx
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.test;

  pythonImportsCheck = [ "sphinxcontrib.mermaid" ];

  meta = {
    description = "Mermaid diagrams in yours sphinx powered docs";
    homepage = "https://github.com/mgaitan/sphinxcontrib-mermaid";
    changelog = "https://github.com/mgaitan/sphinxcontrib-mermaid/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ adamecooper ];
    mainProgram = "sphinxcontrib-mermaid";
  };
}
