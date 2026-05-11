{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "mweinelt";
  domain = "prometheus_sensor";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mweinelt";
    repo = "ha-prometheus-sensor";
    tag = version;
    hash = "sha256-uIC/yGqjigVURZYVMMLY33VqRbadSCqTtT0Qtaq71uc=";
  };

  meta = {
    changelog = "https://github.com/mweinelt/ha-prometheus-sensor/blob/${version}/CHANGELOG.md";
    description = "Import prometheus query results into Home Assistant";
    homepage = "https://github.com/mweinelt/ha-prometheus-sensor";
    maintainers = with lib.maintainers; [ hexa ];
    license = lib.licenses.mit;
  };
}
