{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vector";
  version = "0.11.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/e0wZDWIIm9vi37NEkIEitQj0p1M132AAO6id0eaA5Y=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];
  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vector" ];

  meta = with lib; {
    description = "A Python 3.7+ library for 2D, 3D, and Lorentz vectors, especially arrays of vectors, to solve common physics problems in a NumPy-like way";
    homepage = "https://github.com/scikit-hep/vector";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
