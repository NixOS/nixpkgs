{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pythonOlder
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "solaredge";
  version = "0.0.4";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q4gib0l3qnlpncg84ki027vr1apjlr47vd6845rpk7zkm8lqgfz";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
    requests
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "solaredge" ];

  meta = with lib; {
    description = "Python wrapper for Solaredge monitoring service";
    homepage = "https://github.com/bertouttier/solaredge";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
