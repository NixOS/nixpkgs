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
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "hultenvp";
    repo = "solis-sensor";
    rev = "v${version}";
    hash = "sha256-0l7Kf4xS9LOUSVMsuaao8sgP7xbig9hmcmgDNh99Rj0=";
  };

  dependencies = [ aiofiles ];

  dontCheckManifest = true; # aiofiles version constraint mismatch

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Home Assistant integration for the SolisCloud PV Monitoring portal via SolisCloud API";
    changelog = "https://github.com/hultenvp/solis-sensor/releases/tag/v${version}";
    homepage = "https://github.com/hultenvp/solis-sensor";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
