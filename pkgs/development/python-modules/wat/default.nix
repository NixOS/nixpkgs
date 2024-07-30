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
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "wat";
    rev = version;
    hash = "sha256-ibbWM2L/GoJVg8RxtsBSBn/qA+KIkC5+wq5YH6mtiUs=";
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
