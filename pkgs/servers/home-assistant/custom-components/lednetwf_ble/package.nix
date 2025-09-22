{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  bluetooth-sensor-state-data,
  bleak-retry-connector,
  bleak,
  nix-update-script,
}:
let
  version = "0.0.15.1";
in
buildHomeAssistantComponent {
  owner = "8none1";
  domain = "lednetwf_ble";
  inherit version;

  src = fetchFromGitHub {
    owner = "8none1";
    repo = "lednetwf_ble";
    tag = "v${version}";
    hash = "sha256-LSVvwJZFtBC+iwxfZ3R8msPvrvimPw2Tjzqw6Dx7ZsM=";
  };

  dependencies = [
    bluetooth-sensor-state-data
    bleak-retry-connector
    bleak
  ];

  # Currently there are no tests run, so we skip
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Home Assistant custom integration for LEDnetWF devices";
    homepage = "https://github.com/8none1/lednetwf_ble";
    changelog = "https://github.com/8none1/lednetwf_ble/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blenderfreaky ];
  };
}
