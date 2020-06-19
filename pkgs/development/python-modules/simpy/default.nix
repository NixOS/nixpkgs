{ buildPythonPackage, fetchPypi, lib, setuptools_scm, pytestCheckHook }:

buildPythonPackage rec {
  pname = "simpy";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b36542e2faab612f861c5ef4da17220ac1553f5892b3583c67281dbe4faad404";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://simpy.readthedocs.io/en/latest/";
    description = "A process-based discrete-event simulation framework based on standard Python.";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ shlevy ];
  };
}
