{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, six
}:

buildPythonPackage rec {
  pname = "ucsmsdk";
  version = "0.9.15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-xNRfsIfhoVI5ORWn6NmLCuMMJregIZWQ20QBiBsA1Pc=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
