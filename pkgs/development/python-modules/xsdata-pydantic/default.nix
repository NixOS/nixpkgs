{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  xsdata,
  pydantic,
  click,
  click-default-group,
  jinja2,
  docformatter,
  toposort,
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

  nativeCheckInputs = [
    click
    click-default-group
    docformatter
    jinja2
    toposort
    pytestCheckHook
  ];

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
