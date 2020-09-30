{ buildPythonPackage
, fetchPypi
, lib
, isPy3k
}:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "tensorboard_plugin_wit";
  format = "wheel";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    abi = "none";
    platform = "any";
    sha256 = "0nv855qm2fav70lndsrv810pqgg41sbmd70fk86wk18ih825yxzf";
  };

  meta = {
    homepage = https://github.com/tensorflow/addons;
    description = "Useful extra functionality for TensorFlow 2.x maintained by SIG-addons";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vladmaraev ];
  };
}
