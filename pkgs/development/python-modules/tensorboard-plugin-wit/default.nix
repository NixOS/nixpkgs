{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "tensorboard_plugin_wit";
  version = "1.7.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    sha256 = "0nv855qm2fav70lndsrv810pqgg41sbmd70fk86wk18ih825yxzf";
  };

  meta = with lib; {
    description = "What-If Tool TensorBoard plugin.";
    homepage = "http://tensorflow.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
