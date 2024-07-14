{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  pythonOlder,
  pytz,
  requests,
}:

buildPythonPackage rec {
  pname = "solaredge";
  version = "0.0.4";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3z1MUZ3/zJsLQabtQzKVV4W8jwBxEvSYvdTiQcGKj2A=";
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
