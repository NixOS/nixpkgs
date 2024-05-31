{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
}:

buildHomeAssistantComponent rec {
  owner = "mweinelt";
  domain = "prometheus_sensor";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mweinelt";
    repo = "ha-prometheus-sensor";
    rev = "refs/tags/${version}";
    hash = "sha256-xfLAfTBgJjrRU1EFcbRvzUSq4m+dd6izaxP9DMisz/0=";
  };

  dontBuild = true;

  meta = with lib; {
    changelog = "https://github.com/mweinelt/ha-prometheus-sensor/blob/${version}/CHANGELOG.md";
    description = "Import prometheus query results into Home Assistant";
    homepage = "https://github.com/mweinelt/ha-prometheus-sensor";
    maintainers = with maintainers; [ hexa ];
    license = licenses.mit;
  };
}
