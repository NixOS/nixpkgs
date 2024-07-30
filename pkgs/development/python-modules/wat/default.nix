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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "wat";
    rev = version;
    hash = "sha256-WCMMj4KtfWOp6LsS4XHD/M/iepstVasHknEvEUTMMM8=";
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
