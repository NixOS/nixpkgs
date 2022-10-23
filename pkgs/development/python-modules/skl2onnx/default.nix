{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, protobuf
, onnx
, scikit-learn
, onnxconverter-common
, onnxruntime
, pandas
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "skl2onnx";
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XzUva5uFX/rGMFpwfwLH1Db0Nok47pBJCSqVo1ZcJz0=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "scikit-learn>=0.19" ""
    substituteInPlace requirements.txt \
      --replace "scikit-learn<=1.1.1" "scikit-learn"
  '';

  propagatedBuildInputs = [
    numpy
    scipy
    protobuf
    onnx
    scikit-learn
    onnxconverter-common
  ];

  checkInputs = [
    onnxruntime
    pandas
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "tests" ];

  # Core dump
  doCheck = false;

  meta = {
    description = "Convert scikit-learn models to ONNX";
    maintainers = with lib.maintainers; [ fridh ];
    license = with lib.licenses; [ asl20 ];
  };
}
