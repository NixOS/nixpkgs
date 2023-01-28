{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BZePwk/5PzSQRa6hH6OtHvqA6rGcq2JR6sdBfGMRodI=";
  };

  # fails..
  doCheck = false;

  pythonImportsCheck = [
    "zodbpickle"
  ];

  meta = with lib; {
    description = "Fork of Python's pickle module to work with ZODB";
    homepage = "https://github.com/zopefoundation/zodbpickle";
    changelog = "https://github.com/zopefoundation/zodbpickle/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
