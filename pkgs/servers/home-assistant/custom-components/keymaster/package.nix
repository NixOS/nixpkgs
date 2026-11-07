{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "FutureTense";
  domain = "keymaster";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "FutureTense";
    repo = "keymaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3jjEfIWVFgGEsD5URDvT3l8Do0dn9VDcer62nIIyiHM=";
  };

  meta = {
    changelog = "https://github.com/FutureTense/keymaster/releases/tag/v${finalAttrs.version}";
    description = "Home Assistant integration for managing access codes on smart locks";
    homepage = "https://github.com/FutureTense/keymaster";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frantathefranta ];
  };
})
