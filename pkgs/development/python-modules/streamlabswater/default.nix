{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "streamlabswater";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kXG0Wg3PVryMBQ9RMMtEzudMiwVQq7Ikw2OK7JcBojA=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "streamlabswater" ];

  meta = {
    description = "Python library for the StreamLabs API";
    homepage = "https://github.com/streamlabswater/stream-python";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
