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
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${version}";
    hash = "sha256-EEvy0UtmBlgC3b57SOwr7dI49R7PYeFqsZKyzo0zx9w=";
  };

  buildAndTestSubdir = "py";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-ihNFGlPhPLCIDvFnMqKA+flD/mv9wcKgQ1txO71xOp4=";
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
