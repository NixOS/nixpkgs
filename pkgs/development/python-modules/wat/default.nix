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
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "wat";
    rev = version;
    hash = "sha256-oAvweCZxUd3Sd2swjYFL3hZ3szlpVjefYb5apkR9P5U=";
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
