{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  gviz-api,
  protobuf,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "tensorboard_plugin_profile";
  version = "2.11.1";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-t9AZg0BGjDcOxtoRBHZO0joIgLHpoKqEUY4pxmw8sjg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    gviz-api
    protobuf
    werkzeug
  ];

  meta = with lib; {
    description = "Profile Tensorboard Plugin";
    homepage = "http://tensorflow.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
