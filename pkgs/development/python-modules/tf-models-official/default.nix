{ lib
, buildPythonPackage
, fetchPypi
, gin-config
, google-api-python-client
, kaggle
, numpy
, pandas
, py-cpuinfo
, pycocotools
, pyyaml
, sentencepiece
, seqeval
, tensorflow
, tensorflow-addons
, tensorflow-datasets
}:

buildPythonPackage rec {
  pname = "tf-models-official";
  version = "2.8.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tf_models_official";
    inherit version;
    sha256 = "sha256-HlhQaSAlUPRBaMYhgISYeSDuHpvny8AoLjjoUm77U7M=";
    format = "wheel";
  };

  # https://github.com/tensorflow/models/blob/master/official/requirements.txt
  propagatedBuildInputs = [
    gin-config
    google-api-python-client
    kaggle
    numpy
    pandas
    py-cpuinfo
    pycocotools
    pyyaml
    sentencepiece
    seqeval
    tensorflow
    tensorflow-addons
    tensorflow-datasets
  ];

  meta = with lib; {
    description = "TensorFlow Official Models";
    homepage = "https://github.com/tensorflow/models";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
