{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchNpmDeps,
  aiofiles,
  jinja2,
  joserfc,
  nodejs,
  npmHooks,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pytest-cov-stub,
}:

buildHomeAssistantComponent rec {
  owner = "christaangoossens";
  domain = "auth_oidc";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "christiaangoossens";
    repo = "hass-oidc-auth";
    tag = "v${version}";
    hash = "sha256-vwQDrMM4phbrXT85Syyz6hWEIhLB3TKNNTM04OdvNWk=";
  };

  postPatch = ''
    # Tests import directly from auth_oidc, but the component is installed
    # under custom_components.auth_oidc
    for f in tests/test_hass_webserver.py tests/test_state_store.py; do
      substituteInPlace "$f" \
        --replace-fail "from auth_oidc" "from custom_components.auth_oidc"
    done
  '';

  env.npmDeps = fetchNpmDeps {
    name = "${domain}-npm-deps";
    inherit src;
    hash = "sha256-yAm08NVz2Ln6ob9LoPfxuz6U1oBS4AEydIQHhv0WpOg=";
  };

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  dependencies = [
    aiofiles
    jinja2
    joserfc
  ];

  postBuild = ''
    npm run css
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    pytest-cov-stub
  ];

  meta = {
    changelog = "https://github.com/christiaangoossens/hass-oidc-auth/releases/tag/v${version}";
    description = "OpenID Connect authentication provider for Home Assistant";
    homepage = "https://github.com/christiaangoossens/hass-oidc-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
