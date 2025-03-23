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
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "wat";
    rev = version;
    hash = "sha256-I6SKmaSrY/fev2NVcZ2FVTKKS85jmEzw7OzTg3U1MFo=";
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
