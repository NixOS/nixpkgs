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
  version = "6.1.1";
  disabled = isPy27; # setup.py no longer py3 compat

  src = fetchPypi {
    inherit pname version;
    sha256 = "807da52ee0d4fc1241c8f8a04d274a28d4b23d3a5f942152497d19405482d04f";
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
