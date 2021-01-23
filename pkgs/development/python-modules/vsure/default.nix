{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lsr0wl1dwbzpn68ww348yk6v42bw89nrghz5gjsimrr428zw6qn";
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
