{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  six,
}:

buildPythonPackage rec {
  pname = "ucsmsdk";
  version = "0.9.21";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-iqwU42Im4/YyxefkJZ8Zn5CddjUzuZk/7zjLD/0pHm4=";
  };

  propagatedBuildInputs = [
    pyparsing
    six
  ];

  # most tests are broken
  doCheck = false;

  pythonImportsCheck = [ "ucsmsdk" ];

  meta = with lib; {
    description = "Python SDK for Cisco UCS";
    homepage = "https://github.com/CiscoUcs/ucsmsdk";
    changelog = "https://github.com/CiscoUcs/ucsmsdk/blob/v${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
