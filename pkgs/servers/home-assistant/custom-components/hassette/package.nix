{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  hassette-client,
}:

buildHomeAssistantComponent rec {
  owner = "NodeJSmith";
  domain = "hassette";
  version = "0.5.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-hassette";
    tag = "v${version}";
    hash = "sha256-KEPIgZ+2M2xcd55O0QvjTapjuz2iPvG5xsXjY+dV2BM=";
  };

  # Match on the package name, not the pinned version: the pin moves with every
  # upstream release, and this has to keep working when the package is bumped.
  postPatch = ''
    substituteInPlace custom_components/hassette/manifest.json \
      --replace-fail '"hassette-client==' '"hassette-client>='
  '';

  dependencies = [ hassette-client ];

  # The test suite needs a running hassette instance next to
  # pytest-homeassistant-custom-component.
  doCheck = false;

  meta = {
    changelog = "https://github.com/NodeJSmith/hass-hassette/releases/tag/v${version}";
    description = "Integration that exposes a hassette instance's apps and devices to Home Assistant";
    homepage = "https://github.com/NodeJSmith/hass-hassette";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
}
