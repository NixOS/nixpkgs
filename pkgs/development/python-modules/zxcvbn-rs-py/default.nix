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
  version = "0.2.0";

  pyproject = true;

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  src = fetchPypi {
    pname = "zxcvbn_rs_py";
    inherit version;
    hash = "sha256-DQzdOngHGZma2NyfrNuMppG6GzpGoKfwVQGUVmN7erA=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-tb0puFu4T3KW75U7GXjYzjH72diH/tboSwmpnkGwG0k=";
  };

  pythonImportsCheck = [ "zxcvbn_rs_py" ];

  meta = with lib; {
    description = "Python bindings for zxcvbn-rs, the Rust implementation of zxcvbn";
    homepage = "https://github.com/fief-dev/zxcvbn-rs-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
