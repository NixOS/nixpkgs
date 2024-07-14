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
    hash = "sha256-gYqldmdpOBBBXcIDuj918VQekxqNwwtuiyFWNUGnA4g=";
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
