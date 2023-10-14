{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, six
}:

buildPythonPackage rec {
  pname = "ucsmsdk";
  version = "0.9.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CiscoUcs";
    repo = "ucsmsdk";
    rev = "v${version}";
    hash = "sha256-lSkURvKRgW+qV1A8OT4WYsMGlxxIqaFnxQ3Rnlixdw0=";
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
