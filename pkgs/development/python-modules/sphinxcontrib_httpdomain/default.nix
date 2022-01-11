{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-httpdomain";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2059cfabd0cca8fcc3455cc8ffad92f0915a7d3bb03bfddba078a6a0f35beec5";
  };

  propagatedBuildInputs = [ sphinx ];

  # Check is disabled due to this issue:
  # https://bitbucket.org/pypa/setuptools/issue/137/typeerror-unorderable-types-str-nonetype
  doCheck = false;

  meta = with lib; {
    description = "Provides a Sphinx domain for describing RESTful HTTP APIs";
    homepage = "https://bitbucket.org/birkenfeld/sphinx-contrib";
    license = licenses.bsd0;
  };

}
