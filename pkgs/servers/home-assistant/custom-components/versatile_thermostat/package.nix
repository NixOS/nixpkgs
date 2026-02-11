{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  numpy,
  scipy,
  gitUpdater,
}:

buildHomeAssistantComponent rec {
  owner = "jmcollin78";
  domain = "versatile_thermostat";
  version = "8.6.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = version;
    hash = "sha256-jd6+detoxlx9yDHEBQeFema+HLdN1C4lw1/Tk314xas=";
  };

  dependencies = [
    numpy
    scipy
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
