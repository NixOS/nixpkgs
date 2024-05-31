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
    sha256 = "a6ecc02377ac5ee9d65a6a8ad45c9ff1dac8ccee19400a5950fb51d594214ca5";
  };

  # No tests are available
  doCheck = false;

  pythonImportsCheck = [ "varint" ];

  meta = with lib; {
    description = "A basic varint implementation in python";
    homepage = "https://github.com/fmoo/python-varint";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
