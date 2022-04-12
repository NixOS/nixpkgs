{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytorch
, pydeprecate
, pytest
, pytest-doctestplus
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "torchmetrics";
  version = "0.7.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "h150Sm22PIh1cmDWPLgJGdA5hzSn9Fb46kGBuy25V9g=";
  };
  propagatedBuildInputs = [ numpy pytorch pydeprecate ];
  checkInputs = [ pytest pytest-doctestplus pytestCheckHook ];

  meta = with lib; {
    description = "Machine learning metrics for distributed, scalable PyTorch applications.";
    homepage = "https://github.com/PyTorchLightning/metrics";
    license = licenses.asl20;
    maintainers = with maintainers; [ cfhammill ];
  };

}
