{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pkgs,
}:
buildPythonPackage rec {
  pname = "yara-x";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${version}";
    hash = "sha256-C8wBGmilouNcNN3HkwvSTWcZY1fe0jVc2TeWDN4w5xA=";
  };

  buildAndTestSubdir = "py";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-afCBuWr12trjEIDvE0qnGFxTXU7LKZCzZB8RqgqperY=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [ pkgs.yara-x ];

  pythonImportsCheck = [ "yara_x" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "The official Python library for YARA-X";
    homepage = "https://github.com/VirusTotal/yara-x/tree/main/py";
    changelog = "https://github.com/VirusTotal/yara-x/tree/v${version}/py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ivyfanchiang ];
  };
}
