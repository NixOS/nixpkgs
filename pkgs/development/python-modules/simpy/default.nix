{ buildPythonPackage
, fetchPypi
, isPy27
, lib
, setuptools
, setuptools-scm
, py
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "simpy";
  version = "4.1.1";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BtB1CniEsR4OjiDOC8fG1O1fF0PUVmlTQNE/3/lQAaY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://simpy.readthedocs.io/en/${version}/";
    description = "Process-based discrete-event simulation framework based on standard Python";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ dmrauh shlevy ];
  };
}
