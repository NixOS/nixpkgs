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
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "wat";
    rev = version;
    hash = "sha256-vTq+R/EBkBm27qWR4S9Za6/ppfWD9CLE21SXhTabkhc=";
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
