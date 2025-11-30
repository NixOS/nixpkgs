{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  streamlit,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "streamlit-searchbox";
  version = "0.1.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-wrzr";
    repo = "streamlit-searchbox";
    rev = "c770f6d126945e357664c2cf40b03b7c0c660713";
    hash = "sha256-Y60R3QFoy3fey2ZdkKKJu7/zx9ooO/zllZgnjGI2wvU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ streamlit ];

  doCheck = true;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "streamlit_searchbox" ];

  meta = {
    description = "Streamlit component for dynamic searchboxes with autocomplete";
    homepage = "https://github.com/m-wrzr/streamlit-searchbox";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.carman ];
  };
}
