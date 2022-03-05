{ lib, fetchPypi, buildPythonPackage
, gviz-api
, protobuf
, werkzeug
}:

buildPythonPackage rec {
  pname = "tensorboard_plugin_profile";
  version = "2.5.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    sha256 = "16jch9py98h7wrffdiz6j0i3kdykxdp5m0kfxr1fxy2phqanpjqk";
  };

  propagatedBuildInputs = [
    gviz-api
    protobuf
    werkzeug
  ];

  meta = with lib; {
    description = "Profile Tensorboard Plugin.";
    homepage = "http://tensorflow.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
