{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-httpdomain";
  version = "1.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bC3+bKKC119m3zM4absM5zMcAbR122gJ/50Qe3zf4Es=";
  };

  propagatedBuildInputs = [ sphinx ];

  # Check is disabled due to this issue:
  # https://bitbucket.org/pypa/setuptools/issue/137/typeerror-unorderable-types-str-nonetype
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Provides a Sphinx domain for describing RESTful HTTP APIs";
    homepage = "https://bitbucket.org/birkenfeld/sphinx-contrib";
    license = licenses.bsd0;
  };
}
