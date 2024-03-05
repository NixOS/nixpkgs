{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, six
}:

buildPythonPackage rec {
  pname = "ucsmsdk";
  version = "0.9.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-9ksHA8uvBv370/6Umt5iz/4F8VsDDI9X8kVc5Lv0RVk=";
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
