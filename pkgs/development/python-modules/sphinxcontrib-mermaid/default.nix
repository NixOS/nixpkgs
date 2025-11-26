{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  myst-parser,
  pytestCheckHook,
  pyyaml,
  rst2pdf,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-mermaid";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mgaitan";
    repo = "sphinxcontrib-mermaid";
    tag = version;
    hash = "sha256-aeACJT5KWDTbjGJEB4s7ff9LilXcj/8Rxbz5uYXiUY8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sphinx
    pyyaml
    rst2pdf
  ];

  nativeCheckInputs = [
    myst-parser
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sphinxcontrib.mermaid" ];

  meta = {
    description = "Mermaid diagrams in yours sphinx powered docs";
    homepage = "https://github.com/mgaitan/sphinxcontrib-mermaid";
    changelog = "https://github.com/mgaitan/sphinxcontrib-mermaid/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
