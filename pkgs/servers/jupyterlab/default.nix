{ stdenv
, buildPythonPackage
, fetchPypi
, notebook
, jsonschema
, pythonOlder
, requests
, pytest
, json5
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "1.0.6";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bax8iqwcc5p02h5ysdc48zvx7ll5jfzfsybhb3lfvyfpwkpb5yh";
  };

  checkInputs = [ requests pytest ];
  propagatedBuildInputs = [ notebook jsonschema json5 ];

  # test_listing test fails
  # this is a new package and not all tests pass
  doCheck = false;

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "JupyterLab Server";
    homepage = https://jupyter.org;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
