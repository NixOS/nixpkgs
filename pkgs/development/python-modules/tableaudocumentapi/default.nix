{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "tableaudocumentapi";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c7d01f01758dd6e50ff2fc915c6087c0da17298635e6635581aaf25c934d6ce";
  };

  # tests not inclued with release
  doCheck = false;

  meta = with lib; {
    description = "A Python module for working with Tableau files";
    homepage = "https://github.com/tableau/document-api-python";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
