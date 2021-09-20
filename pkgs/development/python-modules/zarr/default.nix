{ lib
, buildPythonPackage
, asciitree
, fasteners
, fetchPypi
, numcodecs
, numpy
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "2.10.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jKjlBcrbT3+XqrTkGTuzArYzi/VFk8mP51gb9XTthkw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asciitree
    fasteners
    numcodecs
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zarr" ];

  meta = with lib; {
    description = "An implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
