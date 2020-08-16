{ stdenv, fetchPypi, buildPythonPackage
, requests }:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "750b2d2300e8590cd56414ab7bbbc8dfcaf8c27102b342398955812176499498";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "The official Todoist Python API library";
    homepage = "https://todoist-python.readthedocs.io/en/latest/";
    license = stdenv.lib.licenses.mit;
  };
}
