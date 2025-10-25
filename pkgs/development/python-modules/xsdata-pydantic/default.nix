{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  xsdata,
  pydantic,
}:

buildPythonPackage rec {
  pname = "xsdata-pydantic";
  version = "24.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tefra";
    repo = "xsdata-pydantic";
    tag = "v${version}";
    hash = "sha256-ExgAXQRNfGQRSZdMuWc8ldJPqz+3c4Imgu75KXLXHNk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    xsdata
    pydantic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "xsdata_pydantic"
  ];

  meta = {
    description = "Naive XML & JSON Bindings for python pydantic classes!";
    homepage = "https://github.com/tefra/xsdata-pydantic";
    maintainers = with lib.maintainers; [ berrij ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
