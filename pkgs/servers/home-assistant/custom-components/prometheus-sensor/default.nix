{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
}:

buildHomeAssistantComponent rec {
  pname = "prometheus-sensor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mweinelt";
    repo = "ha-prometheus-sensor";
    rev = "refs/tags/${version}";
    hash = "sha256-10COLFXvmpm8ONLyx5c0yiQdtuP0SC2NKq/ZYHro9II=";
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
