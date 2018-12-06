{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-httpdomain";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0srg8lwf4m1hyhz942fcdfxh689xphndngiidb575qmfbi89gc7a";
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
