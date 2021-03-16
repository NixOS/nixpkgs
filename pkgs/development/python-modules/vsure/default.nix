{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tnUL9krKHqHR79EROsmVflCy9uO1n0iV6evQc/YpxnM=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "verisure" ];

  meta = with lib; {
    description = "Python library for working with verisure devices";
    homepage = "https://github.com/persandstrom/python-verisure";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
