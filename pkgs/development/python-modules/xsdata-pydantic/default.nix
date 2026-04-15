{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pydantic,
  xsdata,

  # tests
  click,
  click-default-group,
  docformatter,
  jinja2,
  pytestCheckHook,
  toposort,
}:

buildPythonPackage (finalAttrs: {
  pname = "xsdata-pydantic";
  version = "24.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tefra";
    repo = "xsdata-pydantic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ExgAXQRNfGQRSZdMuWc8ldJPqz+3c4Imgu75KXLXHNk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    xsdata
  ];

  nativeCheckInputs = [
    click
    click-default-group
    docformatter
    jinja2
    pytestCheckHook
    toposort
  ];

  pythonImportsCheck = [ "xsdata_pydantic" ];

  disabledTests = [
    # AssertionError: SystemExit(2) is not None
    "test_complete"
  ];

  meta = {
    description = "Naive XML & JSON Bindings for python pydantic classes";
    homepage = "https://github.com/tefra/xsdata-pydantic";
    changelog = "https://github.com/tefra/xsdata-pydantic/blob/${finalAttrs.src.tag}/CHANGES.md";
    maintainers = with lib.maintainers; [ berrij ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
