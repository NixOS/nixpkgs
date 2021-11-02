{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, python
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "traits";
  version = "6.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "770241df047feb9e3ed4c26a36c2468a5b754e6082a78eeb737f058bd45344f5";
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
