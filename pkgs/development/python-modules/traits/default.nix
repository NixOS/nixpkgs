{ stdenv
, buildPythonPackage
, fetchPypi
, python
, pytest
, numpy
, isPy33
}:

buildPythonPackage rec {
  pname = "traits";
  version = "5.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a17qmpw0z9h7ybh5yxrghvkcf2q90vgxzbnv1n4i0fxhi7mjy3s";
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
  doCheck = isPy33;

  meta = with stdenv.lib; {
    description = "Explicitly typed attributes for Python";
    homepage = https://pypi.python.org/pypi/traits;
    license = "BSD";
  };

}
