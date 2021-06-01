{ lib
, buildPythonPackage
, fetchPypi
, pytest
, colorama
, scikitlearn
, future
, tqdm
, scipy
, requests
, tabulate
, terminaltables
, tensorflow_2
, tensorflow-tensorboard_2
 }:
 
buildPythonPackage rec {
  pname = "keras-tuner";
  version = "1.0.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "a9626842bc032bb0c8f3152bbc90910f50db3221f8aa980ec82ac729692707ec";
  };
  
  propagatedBuildInputs = [ 
    colorama
	scikitlearn
	future
	tqdm
	scipy
	requests
	tabulate
	terminaltables
  ];
  checkInputs = [ 
    pytest
	tensorflow_2
	tensorflow-tensorboard_2
  ];
  meta = {
    homepage = "https://keras-team.github.io/keras-tuner";
    description = "hyperparameter tuning for TensorFlow/Keras";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
