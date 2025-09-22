{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-programoutput";
  version = "0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NextThought";
    repo = "sphinxcontrib-programoutput";
    tag = version;
    hash = "sha256-WI4R96G4cYYTxTwW4dKAayUNQyhVSrjhdWJyy8nZBUk=";
  };

  build-system = [ setuptools ];

  buildInputs = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinxcontrib.programoutput" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension to include program output";
    homepage = "https://github.com/NextThought/sphinxcontrib-programoutput";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
