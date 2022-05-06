{ lib
, buildPythonPackage
, fetchPypi
, numpy
, cudatoolkit
}:

buildPythonPackage rec {
  pname = "warp-lang";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-htcUS/qPqL2eyT7c+rnE/SQPR7mAVwf/F2OlDtJVMs8=";
  };

  propagatedBuildInputs = [ cudatoolkit numpy ];
  pythonImportsCheck = [ "warp" ];

  # Needs CUDA device at runtime to run the tests
  doCheck = false;

  meta = with lib; {
    description = "A Python framework for high performance GPU simulation and graphics";
    homepage = "https://github.com/NVIDIA/warp";
    maintainers = with maintainers; [ marcosrdac ];
    license = licenses.nvidia-warp;
  };
}
