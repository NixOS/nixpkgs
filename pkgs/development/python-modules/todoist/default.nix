{ stdenv, fetchPypi, buildPythonPackage
, requests }:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f4d402137f02f415f99acaa9d7ab24016687202dec9a191aee4745a9ce67dc6";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "The official Todoist Python API library";
    homepage = http://todoist-python.readthedocs.io/en/latest/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
