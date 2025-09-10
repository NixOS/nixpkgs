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
  version = "0.9.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    tag = "v${version}";
    hash = "sha256-zpb43Id6uHBKpEORDGKNW8lXP10fQJm9lGOztxaTZSI=";
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
