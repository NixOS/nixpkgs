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
  version = "2.11.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-browser_mod";
    tag = "v${version}";
    hash = "sha256-IenC39xaHxD7Q+r8w4zfn8ZwF+s7i+dliwG4lOPPLHk=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmBuildHook
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-DmN2gWhtfGhqLJpSXW7XAt9stvsH6jJfR4FUQOZqh6M=";
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
