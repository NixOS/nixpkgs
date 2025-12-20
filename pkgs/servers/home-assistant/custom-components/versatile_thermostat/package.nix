{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  gitUpdater,
}:

buildHomeAssistantComponent rec {
  owner = "jmcollin78";
  domain = "versatile_thermostat";
  version = "8.3.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/${version}";
    hash = "sha256-WKT7M/jVsyP3LwYz42FpdLEP3u1mEZTo3vWvtWDQlcE=";
  };

  passthru.updateScript = gitUpdater { ignoredVersions = "(Alpha|Beta|alpha|beta).*"; };

  meta = {
    changelog = "https://github.com/jmcollin78/versatile_thermostat/releases/tag/${version}";
    description = "Full-featured thermostat";
    homepage = "https://github.com/jmcollin78/versatile_thermostat";
    maintainers = with lib.maintainers; [ pwoelfel ];
    license = lib.licenses.mit;
  };
}
