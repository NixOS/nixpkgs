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
  version = "2.13.5";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-browser_mod";
    tag = "v${version}";
    hash = "sha256-uVMefvOiw0CMcpOSo8dJn4NazZxACvPscV4GqtyQXSY=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmBuildHook
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-eX7dyDxcaPMhTOAhAbcw7beP3cwBKRz457OZgp3LRAA=";
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
