{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  gitUpdater,
}:

buildHomeAssistantComponent rec {
  owner = "jmcollin78";
  domain = "versatile_thermostat";
  version = "7.1.5";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/${version}";
    hash = "sha256-XCDWByw/2xUjub/fNGvpIGzDyn3rq+JMI7syI1oPus0=";
  };

  passthru.updateScript = gitUpdater { ignoredVersions = "(Alpha|Beta|alpha|beta).*"; };

  meta = {
    changelog = "https://github.com/jmcollin78/versatile_thermostat/releases/tag/${version}";
    description = "A full-featured thermostat";
    homepage = "https://github.com/jmcollin78/versatile_thermostat";
    maintainers = with lib.maintainers; [ pwoelfel ];
    license = lib.licenses.mit;
  };
}
