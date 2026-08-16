{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiofiles,
  distutils,
  nix-update-script,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "smartHomeHub";
  domain = "smartir";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "smartHomeHub";
    repo = "SmartIR";
    tag = finalAttrs.version;
    hash = "sha256-gi5xlBOY6ek5roQKNqL7I0jrmJNPrxHHwEqOB/n2Itk=";
  };

  dependencies = [
    aiofiles
    distutils
  ];

  postInstall = ''
    cp -r codes $out/custom_components/smartir/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/smartHomeHub/SmartIR/releases/tag/${finalAttrs.version}";
    description = "Integration for Home Assistant to control climate, TV and fan devices via IR/RF controllers (Broadlink, Xiaomi, MQTT, LOOKin, ESPHome)";
    homepage = "https://github.com/smartHomeHub/SmartIR";
    maintainers = with lib.maintainers; [ azuwis ];
    license = lib.licenses.mit;
  };
})
