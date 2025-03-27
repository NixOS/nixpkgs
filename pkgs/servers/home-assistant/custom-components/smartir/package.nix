{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiofiles,
  distutils,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "smartHomeHub";
  domain = "smartir";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "smartHomeHub";
    repo = "SmartIR";
    tag = version;
    hash = "sha256-Sy1wxVUApKWm9TlDia2Gwd+mIi7WbDkzJrAtyb0tTbM=";
  };

  dependencies = [
    aiofiles
    distutils
  ];

  dontBuild = true;

  postInstall = ''
    cp -r codes $out/custom_components/smartir/
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/smartHomeHub/SmartIR/releases/tag/v${version}";
    description = "Integration for Home Assistant to control climate, TV and fan devices via IR/RF controllers (Broadlink, Xiaomi, MQTT, LOOKin, ESPHome)";
    homepage = "https://github.com/smartHomeHub/SmartIR";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.mit;
  };
}
