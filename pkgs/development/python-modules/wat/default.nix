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
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "wat";
    rev = version;
    hash = "sha256-52ZqLOOWxm3BtF36i9PWnNiWKQi4xjXi8vVw8pXnaVU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    nuclear
    pydantic
  ];
  pythonImportsCheck = [ "wat" ];

  meta = with lib; {
    homepage = "https://igrek51.github.io/wat/";
    description = "Deep inspection of python objects";
    license = licenses.mit;
    maintainers = with maintainers; [ parras ];
  };
}
