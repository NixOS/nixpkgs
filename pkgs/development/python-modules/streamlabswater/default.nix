{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "streamlabswater";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kXG0Wg3PVryMBQ9RMMtEzudMiwVQq7Ikw2OK7JcBojA=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "streamlabswater" ];

  meta = with lib; {
    description = "Python library for the StreamLabs API";
    homepage = "https://github.com/streamlabswater/stream-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
