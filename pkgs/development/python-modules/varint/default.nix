{
  buildPythonPackage,
  fetchPypi,
  lib,
}:
buildPythonPackage rec {
  pname = "varint";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-puzAI3esXunWWmqK1Fyf8drIzO4ZQApZUPtR1ZQhTKU=";
  };

  # No tests are available
  doCheck = false;

  pythonImportsCheck = [ "varint" ];

  meta = with lib; {
    description = "Basic varint implementation in python";
    homepage = "https://github.com/fmoo/python-varint";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
