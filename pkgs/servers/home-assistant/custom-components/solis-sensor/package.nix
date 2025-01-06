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
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "hultenvp";
    repo = "solis-sensor";
    rev = "v${version}";
    hash = "sha256-sjLHridYiF2x5XzW869BNjH9y2WtfvXXsNICKUmpOYM=";
  };

  dependencies = [ aiofiles ];

  dontCheckManifest = true; # aiofiles version constraint mismatch

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Home Assistant integration for the SolisCloud PV Monitoring portal via SolisCloud API";
    changelog = "https://github.com/hultenvp/solis-sensor/releases/tag/v${version}";
    homepage = "https://github.com/hultenvp/solis-sensor";
    license = licenses.asl20;
    maintainers = with maintainers; [ jnsgruk ];
  };
}
