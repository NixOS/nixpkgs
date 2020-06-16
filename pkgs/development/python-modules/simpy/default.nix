{ buildPythonPackage, fetchPypi, lib, pytestCheckHook, setuptools
, setuptools_scm }:

buildPythonPackage rec {
  pname = "simpy";
  version = "3.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd8c16ca3cff1574c99fe9f5ea4019c631c327f2bdc842e8b1a5c55f5e3e9d27";
  };

  nativeBuildInputs = [ setuptools_scm setuptools ];

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://simpy.readthedocs.io/en/${version}/";
    description =
      "A process-based discrete-event simulation framework based on standard Python.";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ dmrauh shlevy ];
  };
}
