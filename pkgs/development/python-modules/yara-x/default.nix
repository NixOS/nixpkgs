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
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${version}";
    hash = "sha256-TR9P4QYDxHSpAmPShiRNdNK1c4v3hGAx8mNOEhAo/HQ=";
  };

  buildAndTestSubdir = "py";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-/D4/H/+O1bCHecEO92aq05U3lPG2P/CFTWVlHekuH98=";
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
