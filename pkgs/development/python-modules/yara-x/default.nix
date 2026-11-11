{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  pytestCheckHook,
  pkgs,
}:

buildPythonPackage (finalAttrs: {
  pname = "yara-x";
  version = "1.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NyaiHXBW/IsfhhPEwjKAVS6BwOkZ6bKqWgzzBpmettI=";
  };

  buildAndTestSubdir = "py";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-AHVNM1UHU7HqLcqIy2Jh9YCDLCJ+h2+piyCpV/RQI4I=";
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
    changelog = "https://github.com/VirusTotal/yara-x/tree/${finalAttrs.src.tag}/py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ivyfanchiang
      lesuisse
    ];
  };
})
