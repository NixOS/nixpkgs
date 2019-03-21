{ lib, fetchPypi, buildPythonPackage, fetchurl, pytest, scipy, h5py
, pillow, tensorflow }:

buildPythonPackage rec {
  pname = "tflearn";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "034lvbslcivyj64r4w6xmr90ckmyxmrnkka9kal50x4175h02n1z";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ scipy h5py pillow tensorflow ];

  doCheck = false;

  meta = with lib; {
    description = "Deep learning library featuring a higher-level API for TensorFlow";
    homepage    = "https://github.com/tflearn/tflearn";
    license     = licenses.mit;
  };
}
