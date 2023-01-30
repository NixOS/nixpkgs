{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, numpy
, tqdm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tiler";
  version = "0.5.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2HWO/iJ9RCWNVmw2slu9F/+Mchk3evB5/F8EfbuMI/Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tiler" ];

  meta = with lib; {
    description = "N-dimensional NumPy array tiling and merging with overlapping, padding and tapering";
    homepage = "https://the-lay.github.io/tiler/";
    license = licenses.mit;
    maintainers = with maintainers; [ atila ];
  };
}
