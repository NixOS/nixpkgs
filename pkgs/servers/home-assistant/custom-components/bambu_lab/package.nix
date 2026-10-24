{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  beautifulsoup4,
  homeassistant,
  paho-mqtt,
  pillow,
  pytestCheckHook,
  python-dateutil,
  requests,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "greghesp";
  domain = "bambu_lab";
  version = "2.2.26";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-bambulab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9KsIzem7BjImUW+BTnAUYJ7CnU5bFpet7D2HhmOwTbA=";
  };

  dependencies = [ beautifulsoup4 ];

  nativeCheckInputs = [
    paho-mqtt
    pillow
    pytestCheckHook
    python-dateutil
    requests
  ]
  ++ (homeassistant.getPackages "ssdp" homeassistant.python3Packages);

  disabledTestPaths = [
    # tests the release translation script, fails with NameErrors but is also not run by upstream CI either
    "tests/test_auto_translate.py"
  ];

  meta = {
    description = "Home Assistant integration for Bambu Lab 3D printers";
    longDescription = ''
      Bambu Lab depends on `ffmpeg` and `mqtt`, example how to setup in NixOS `configuration.nix`:

      ```
      { config, lib, pkgs, ... }:
      {
        services.home-assistant = {
          customComponents = [ pkgs.home-assistant-custom-components.bambu_lab ];
          extraComponents = [ "ffmpeg" "mqtt" ];
        };
      }
      ```
    '';
    homepage = "https://github.com/greghesp/ha-bambulab";
    changelog = "https://github.com/greghesp/ha-bambulab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
