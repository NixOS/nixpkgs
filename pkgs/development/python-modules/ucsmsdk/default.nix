{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "ucsmsdk";
  version = "0.9.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    tag = "v${version}";
    hash = "sha256-c2Tvm4xMyda9PoL7VWMCo7/RjSVcHBJQMh4GeTzgz5I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyparsing
    six
  ];

  # most tests are broken
  doCheck = false;

  pythonImportsCheck = [ "ucsmsdk" ];

  meta = with lib; {
    description = "Python SDK for Cisco UCS";
    homepage = "https://github.com/CiscoUcs/ucsmsdk";
    changelog = "https://github.com/CiscoUcs/ucsmsdk/blob/${src.tag}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
