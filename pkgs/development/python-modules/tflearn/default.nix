{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytest,
  scipy,
  h5py,
  pillow,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "tflearn";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "818aa57667693810415dc203ba3f75f1541e931a8dc30b6e8b21563541a70388";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    scipy
    h5py
    pillow
    tensorflow
  ];

  doCheck = false;

  meta = with lib; {
    description = "Deep learning library featuring a higher-level API for TensorFlow";
    homepage = "https://github.com/tflearn/tflearn";
    license = licenses.mit;
  };
}
