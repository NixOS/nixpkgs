{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "tahoma-api";
  version = "0.0.17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "philklei";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YwOKSBlN4lNyS+hfdbQDUq1gc14FBof463ofxtUVLC4=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "tahoma_api" ];

  meta = with lib; {
    description = "Python module to interface with Tahoma REST API";
    homepage = "https://github.com/philklei/tahoma-api/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
