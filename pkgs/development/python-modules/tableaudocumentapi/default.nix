{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "tableaudocumentapi";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc6d44b62cf6ea29916c073686e2f9f35c9902eccd57b8493f8d44a59a2f60d9";
  };

  # tests not inclued with release
  doCheck = false;

  meta = with lib; {
    description = "A Python module for working with Tableau files";
    homepage = https://github.com/tableau/document-api-python;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
