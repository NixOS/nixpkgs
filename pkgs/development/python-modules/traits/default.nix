{ lib, buildPythonPackage, fetchPypi, isPy27, python, numpy }:

buildPythonPackage rec {
  pname = "traits";
  version = "6.3.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4520ef4a675181f38be4a5bab1b1d5472691597fe2cfe4faf91023e89407e2c6";
  };

  propagatedBuildInputs = [ numpy ];

  # Test suite is broken for 3.x on latest release
  # https://github.com/enthought/traits/issues/187
  # https://github.com/enthought/traits/pull/188
  # Furthermore, some tests fail due to being in a chroot
  doCheck = false;

  meta = with lib; {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
