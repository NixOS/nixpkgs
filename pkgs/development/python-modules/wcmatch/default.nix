{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  bracex,
}:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "11.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8rbw+tb14lcUmHI/yzyPrN0Pug3ME58x0y9ZLrZIFT4=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ bracex ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [ "TestTilde" ];

  pythonImportsCheck = [ "wcmatch" ];

  meta = {
    description = "Wildcard File Name matching library";
    homepage = "https://github.com/facelessuser/wcmatch";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
