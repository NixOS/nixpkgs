{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  setuptools,
  coloredlogs,
  executor,
  humanfriendly,
  naturalsort,
  property-manager,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "update-dotdee";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-update-dotdee";
    rev = finalAttrs.version;
    hash = "sha256-2k7FdgWM0ESHQb2za87yhXGaR/rbMYLVcv10QexUH1A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    coloredlogs
    executor
    humanfriendly
    naturalsort
    property-manager
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace-fail " --cov --showlocals --verbose" ""
  '';

  pythonImportsCheck = [ "update_dotdee" ];

  disabledTests = [
    # TypeError: %o format: an integer is required, not str
    "test_executable"
  ];

  meta = {
    description = "Generic modularized configuration file manager";
    mainProgram = "update-dotdee";
    homepage = "https://github.com/xolox/python-update-dotdee";
    changelog = "https://github.com/xolox/python-update-dotdee/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
})
