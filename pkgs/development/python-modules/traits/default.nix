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
  version = "6.2.0";
  disabled = isPy27; # setup.py no longer py3 compat

  src = fetchPypi {
    inherit pname version;
    sha256 = "16fa1518b0778fd53bf0547e6a562b1787bf68c8f6b7995a13bd1902529fdb0c";
  };

  # Use pytest because its easier to discover tests
  buildInputs = [ pytest ];
  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  # Test suite is broken for 3.x on latest release
  # https://github.com/enthought/traits/issues/187
  # https://github.com/enthought/traits/pull/188
  # Furthermore, some tests fail due to being in a chroot
  doCheck = false;

  meta = with lib; {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = "BSD";
  };

}
