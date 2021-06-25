{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, buildPythonPackage
, libiconv
}:

buildPythonPackage rec {
  pname = "wasmer";
  version = "1.0.0";

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

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  buildAndTestSubdir = "packages/api";

  doCheck = false;

  pythonImportsCheck = [ "wasmer" ];

  meta = with lib; {
    description = "Python extension to run WebAssembly binaries";
    homepage = "https://github.com/wasmerio/wasmer-python";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
