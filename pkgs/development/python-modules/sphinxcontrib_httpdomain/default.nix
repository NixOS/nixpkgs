{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-httpdomain";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac40b4fba58c76b073b03931c7b8ead611066a6aebccafb34dc19694f4eb6335";
  };

  propagatedBuildInputs = [ sphinx ];

  # Check is disabled due to this issue:
  # https://bitbucket.org/pypa/setuptools/issue/137/typeerror-unorderable-types-str-nonetype
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Provides a Sphinx domain for describing RESTful HTTP APIs";
    homepage = https://bitbucket.org/birkenfeld/sphinx-contrib;
    license = licenses.bsd0;
  };

}
