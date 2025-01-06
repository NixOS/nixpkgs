{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nuclear,
  pydantic,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wat";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "wat";
    rev = version;
    hash = "sha256-AiCu62Kemlziv7whFmXwsumJSAFxLWPkwm4gFh1IGko=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    nuclear
    pydantic
  ];
  pythonImportsCheck = [ "wat" ];

  meta = {
    homepage = "https://igrek51.github.io/wat/";
    description = "Deep inspection of python objects";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ parras ];
  };
}
