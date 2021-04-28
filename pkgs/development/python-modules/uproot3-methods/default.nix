{ lib
, buildPythonPackage
, fetchPypi
, numpy
, awkward0
}:

buildPythonPackage rec {
  version = "0.10.1";
  pname = "uproot3-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd68f90be1ea276360b96369836849df29045f7fe4e534f9ac21ea00798ee358";
  };

  nativeBuildInputs = [ awkward0 ];

  propagatedBuildInputs = [ numpy awkward0 ];

  # No tests on PyPi
  doCheck = false;
  pythonImportsCheck = [ "uproot3_methods" ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/uproot3-methods";
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc SuperSandro2000 ];
  };
}
