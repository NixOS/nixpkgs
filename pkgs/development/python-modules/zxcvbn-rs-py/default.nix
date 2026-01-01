{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "zxcvbn-rs-py";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "zxcvbn_rs_py";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-0nQmgII6F0gj8HCnNAdLvowWBPExPAgXCxWAJuNsc6A=";
=======
    hash = "sha256-DQzdOngHGZma2NyfrNuMppG6GzpGoKfwVQGUVmN7erA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-S6K6ZzW24V2yFV89B+gN+Odc4h3R45lF+emZs69dzYg=";
=======
    hash = "sha256-WkaTEoVQVOwxcTyOIG5oHEvcv65fBEpokl3/6SxqiUw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonImportsCheck = [ "zxcvbn_rs_py" ];

<<<<<<< HEAD
  meta = {
    description = "Python bindings for zxcvbn-rs, the Rust implementation of zxcvbn";
    homepage = "https://github.com/fief-dev/zxcvbn-rs-py/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
=======
  meta = with lib; {
    description = "Python bindings for zxcvbn-rs, the Rust implementation of zxcvbn";
    homepage = "https://github.com/fief-dev/zxcvbn-rs-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
