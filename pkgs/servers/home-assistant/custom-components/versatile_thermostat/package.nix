{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  numpy,
  scipy,
  vtherm-api,
  gitUpdater,
}:

buildHomeAssistantComponent rec {
  owner = "jmcollin78";
  domain = "versatile_thermostat";
  version = "10.5.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = version;
    hash = "sha256-Kj3ZbcsKVHSd/9rqGAWljB0HsDmxpLkWy8LZczyiOS4=";
  };

  dependencies = [
    numpy
    scipy
    vtherm-api
  ];

  passthru.updateScript = gitUpdater { ignoredVersions = "(Alpha|Beta|alpha|beta).*"; };

  meta = {
    changelog = "https://github.com/jmcollin78/versatile_thermostat/releases/tag/${version}";
    description = "Full-featured thermostat";
    homepage = "https://github.com/jmcollin78/versatile_thermostat";
    maintainers = with lib.maintainers; [ pwoelfel ];
    license = lib.licenses.mit;
  };
}
