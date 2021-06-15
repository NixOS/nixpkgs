{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Zh83t7yjZU2NjOgCkqPUHbqvEyEWXGITRgr5d2fLtRI=";
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
