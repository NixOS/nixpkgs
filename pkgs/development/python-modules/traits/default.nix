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
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8369117036fbbe00dbd40e1a01c8775b52bdbfa11db5788168e7c8c56663bac0";
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
