{ buildPythonPackage, fetchPypi, pythonPackages, lib }:

buildPythonPackage rec {
  pname = "svgelements";
  version = "1.9.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ZJkirfgemejVc4Zt/HYoUl9Yv7Kbevj3b2S2GF+874=";
  };

  checkInputs = with pythonPackages; [
    unittestCheckHook
    numpy
    scipy
    pillow
  ];
  pythonImportsCheck = [ "svgelements" ];

  meta = with lib; {
    description = "High fidelity SVG parsing and geometric rendering";
    homepage = "https://github.com/meerk40t/svgelements";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
