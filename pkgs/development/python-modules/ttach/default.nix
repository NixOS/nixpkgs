{ fetchPypi
, pytest
, pytorch
, buildPythonPackage
, lib
}:

buildPythonPackage rec {
  pname = "ttach";
  version = "0.0.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "EgxN2IH+sOnI3WOxVPJlWJHD4gaJtoqU0WK/1VV7y0g=";
  };
  checkInputs = [ pytest pytorch ];
  pythonImportsCheck = [ "ttach" ];

  meta = with lib; {
    description = "Image Test Time Augmentation with PyTorch!";
    homepage = "https://github.com/qubvel/ttach";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cfhammill ];
  };

}
