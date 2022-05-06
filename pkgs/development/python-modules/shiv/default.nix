{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, click
, pip
, setuptools
, wheel
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "shiv";
  version = "1.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec16095a0565906536af7f5e57771e9ae7a061b646ed63ad66ebbc70c30f4d2a";
  };

  propagatedBuildInputs = [ click pip setuptools wheel ];

  pythonImportsCheck = [ "shiv" ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Command line utility for building fully self contained Python zipapps";
    homepage = "https://github.com/linkedin/shiv";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
