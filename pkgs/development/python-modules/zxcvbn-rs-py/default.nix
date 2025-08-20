{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchPypi,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "zxcvbn-rs-py";
  version = "0.1.1";

  pyproject = true;

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  src = fetchPypi {
    pname = "zxcvbn_rs_py";
    inherit version;
    hash = "sha256-7EZJ/WGekfsnisqTs9dwwbQia6OlDEx3MR9mkqSI+gA=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-OA6iyojBMAG9GtjHaIQ9cM0SEMwMa2bKFRIXmqp4OBE=";
  };

  pythonImportsCheck = [ "zxcvbn_rs_py" ];

  meta = with lib; {
    description = "Python bindings for zxcvbn-rs, the Rust implementation of zxcvbn";
    homepage = "https://github.com/fief-dev/zxcvbn-rs-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
