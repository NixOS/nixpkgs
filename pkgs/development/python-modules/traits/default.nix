{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, python
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "traits";
  version = "6.1.0";
  disabled = isPy27; # setup.py no longer py3 compat

  src = fetchPypi {
    inherit pname version;
    sha256 = "97fca523374ae85e3d8fd78af9a9f488aee5e88e8b842e1cfd6d637a6f310fac";
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

  meta = with stdenv.lib; {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = "BSD";
  };

}
