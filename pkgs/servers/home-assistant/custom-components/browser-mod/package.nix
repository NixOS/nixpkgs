{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
}:

buildHomeAssistantComponent rec {
  owner = "thomasloven";
  domain = "browser_mod";
  version = "3.0.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-browser_mod";
    tag = "v${version}";
    hash = "sha256-s9b5JeMyT7pYyHWJtuqw2xVHrmU98kG5dBE4aBsJ+u8=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmBuildHook
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-p+1yRZVyo/EunNjBkdkl8xajZO4U7KpdIu1GzU7L8gE=";
  };

  npmBuildScript = "build";

  meta = {
    description = "Home Assistant integration to turn your browser into a controllable entity and media player";
    homepage = "https://github.com/thomasloven/hass-browser_mod";
    changelog = "https://github.com/thomasloven/hass-browser_mod/blob/${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
