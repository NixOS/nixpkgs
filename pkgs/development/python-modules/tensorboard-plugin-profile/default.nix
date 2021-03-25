{ lib, fetchPypi, buildPythonPackage
, gviz-api
, protobuf
, werkzeug
}:

buildPythonPackage rec {
  pname = "tensorboard_plugin_profile";
  version = "2.4.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    sha256 = "0z6dcjvkk3pzmmmjxi2ybawnfshz5qa3ga92kqj69ld1g9k3i9bj";
  };

  propagatedBuildInputs = [
    gviz-api
    protobuf
    werkzeug
  ];

  meta = with lib; {
    description = "Profile Tensorboard Plugin.";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
