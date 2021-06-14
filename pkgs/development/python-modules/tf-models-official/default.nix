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
  version = "2.4.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tf_models_official";
    inherit version;
    sha256 = "1n3wfbhb9qks67dw44jwj8b0lkf4yb1gzdrw49czgm5ix87hxmp3";
    format = "wheel";
  };

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
