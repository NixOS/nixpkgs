{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "ucsmsdk";
  version = "0.9.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5X7ixOI6ZrB0Vd1A4f/05mr9BgwqC95nKFfyvBvQyQA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyparsing
    six
  ];

  # most tests are broken
  doCheck = false;

  pythonImportsCheck = [ "ucsmsdk" ];

  meta = {
    description = "Python SDK for Cisco UCS";
    homepage = "https://github.com/CiscoUcs/ucsmsdk";
    changelog = "https://github.com/CiscoUcs/ucsmsdk/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
