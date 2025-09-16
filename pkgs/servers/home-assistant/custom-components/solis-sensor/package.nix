{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  aiofiles,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "hultenvp";
  domain = "solis";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "hultenvp";
    repo = "solis-sensor";
    rev = "v${version}";
    hash = "sha256-BhZqJVzNTCZ6XmqR7i6a7bMqk/6V+HXvtqOX4HiYqok=";
  };

  dependencies = [ aiofiles ];

  dontCheckManifest = true; # aiofiles version constraint mismatch

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Home Assistant integration for the SolisCloud PV Monitoring portal via SolisCloud API";
    changelog = "https://github.com/hultenvp/solis-sensor/releases/tag/v${version}";
    homepage = "https://github.com/hultenvp/solis-sensor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
