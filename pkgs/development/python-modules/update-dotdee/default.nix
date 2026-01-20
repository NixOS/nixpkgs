{
  lib,
  buildPythonPackage,
  coloredlogs,
  executor,
  fetchFromGitHub,
  humanfriendly,
  naturalsort,
  property-manager,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "update-dotdee";
  version = "6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-update-dotdee";
    rev = version;
    hash = "sha256-2k7FdgWM0ESHQb2za87yhXGaR/rbMYLVcv10QexUH1A=";
  };

  propagatedBuildInputs = [
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
      --replace " --cov --showlocals --verbose" ""
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
