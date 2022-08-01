{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, mock
, coverage
, unittest2
, attrs
, funcsigs
, six
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sigtools";
  version = "4.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fMhKC6VuNLfxXkM3RCaPEODEp21r/s6JzswaHKkROLY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
  ];

  patchPhase = ''sed -i s/test_suite="'"sigtools.tests"'"/test_suite="'"unittest2.collector"'"/ setup.py'';

  # repeated_test no longer exists in nixpkgs
  # Also see: https://github.com/epsy/sigtools/issues/26
  doCheck = false;
  checkInputs = [ sphinx mock coverage unittest2 ];

  meta = with lib; {
    description = "Utilities for working with 3.3's inspect.Signature objects.";
    homepage = "https://pypi.python.org/pypi/sigtools";
    license = licenses.mit;
  };

}
