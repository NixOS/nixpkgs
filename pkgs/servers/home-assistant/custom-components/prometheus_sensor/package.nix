{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "mweinelt";
  domain = "prometheus_sensor";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "mweinelt";
    repo = "ha-prometheus-sensor";
    tag = version;
    hash = "sha256-N6c4P4dtEO27eVO/X0tUDRFG2IMWbx96fRvsXJLTTVM=";
  };

  meta = {
    changelog = "https://github.com/mweinelt/ha-prometheus-sensor/blob/${version}/CHANGELOG.md";
    description = "Import prometheus query results into Home Assistant";
    homepage = "https://github.com/mweinelt/ha-prometheus-sensor";
    maintainers = with lib.maintainers; [ hexa ];
    license = lib.licenses.mit;
  };
}
