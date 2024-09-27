{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  mock,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "vdf";
  version = "3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "vdf";
    rev = "refs/tags/v${version}";
    hash = "sha256-6ozglzZZNKDtADkHwxX2Zsnkh6BE8WbcRcC9HkTTgPU=";
  };

  patches = [
    # Support appinfo.vdf v29 (required by protontricks 1.12.0)
    (fetchpatch2 {
      url = "https://github.com/Matoking/vdf/commit/981cad270c2558aeb8eccaf42cfcf9fabbbed199.patch";
      hash = "sha256-kLAbbB0WHjxq4rokLoGTPx43BU44EshteR59Ey9JnXo=";
    })
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "vdf" ];

  # Use nix-update-script instead of the default python updater
  # The python updater requires GitHub releases, but vdf only uses tags
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library for working with Valve's VDF text format";
    homepage = "https://github.com/ValvePython/vdf";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
