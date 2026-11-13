{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  homeassistant,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "mtheli";
  domain = "philips_sonicare_ble";
  version = "0.34.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "philips_sonicare_ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2O0McO1eo8gzVR2BskIjFMb5M9WBBkU1TzvI+yonQ+Y=";
  };

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ]
  ++ (homeassistant.getPackages "bluetooth" homeassistant.python3Packages);

  meta = {
    changelog = "https://github.com/mtheli/philips_sonicare_ble/releases/tag/${finalAttrs.src.tag}";
    description = "Philips Sonicare BLE integration for Home Assistant";
    longDescription = ''
      This custom component depends on the bluetooth component, example how to setup in NixOS `configuration.nix`:

      ```
      { pkgs, ... }:
      {
        services.home-assistant = {
          customComponents = [ pkgs.home-assistant-custom-components.philips-sonicare-ble ];
          extraComponents = [ "bluetooth" ];
        };
      }
      ```
    '';
    homepage = "https://github.com/mtheli/philips_sonicare_ble";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
})
