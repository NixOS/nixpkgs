{ lib
, rustPlatform
, fetchFromGitHub
, buildPythonPackage
}:
let
  pname = "wasmer";
  version = "1.0.0";
in buildPythonPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer-python";
    rev = version;
    hash = "sha256-I1GfjLaPYMIHKh2m/5IQepUsJNiVUEJg49wyuuzUYtY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-txOOia1C4W+nsXuXp4EytEn82CFfSmiOYwRLC4WPImc=";
  };

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildAndTestSubdir = "packages/api";

  doCheck = false;

  pythonImportsCheck = [ "wasmer" ];

  meta = with lib; {
    description = "Python extension to run WebAssembly binaries";
    homepage = "https://github.com/wasmerio/wasmer-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
