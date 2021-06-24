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
    sha256 = "sha256-3Wj5C+HqJ2NguWNpg2hJ3ykEX3/k5TT5rCHqAHmO41g=";
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
