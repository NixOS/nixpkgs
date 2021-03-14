{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EFat1sewh0Y9PHs08Grlk2RparA47GqkUv/WJ3J2494=";
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
