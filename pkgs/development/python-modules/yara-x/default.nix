{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  pytestCheckHook,
  pkgs,
}:

buildPythonPackage rec {
  pname = "yara-x";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${version}";
    hash = "sha256-8P3fNLENfoGD+FMeCXX8UwoMzI92JkjV/f3G7d+Li3Y=";
  };

  buildAndTestSubdir = "py";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-ifXe0LKEYMzCo0FIg2E5mCQRUCOlu3nvK2XN/3GM9bk=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [ pkgs.yara-x ];

  pythonImportsCheck = [ "yara_x" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Official Python library for YARA-X";
    homepage = "https://github.com/VirusTotal/yara-x/tree/main/py";
    changelog = "https://github.com/VirusTotal/yara-x/tree/${src.tag}/py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ivyfanchiang
      lesuisse
    ];
  };
}
