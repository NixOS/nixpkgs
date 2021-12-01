{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "tableaudocumentapi";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b1d04817a0fba43d58e1ce23c64ad8dfe54dc029ba5ccae3908944555bb13e0";
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
